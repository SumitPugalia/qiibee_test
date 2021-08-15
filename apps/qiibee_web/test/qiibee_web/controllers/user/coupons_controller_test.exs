defmodule QiibeeWeb.CouponsControllerTest do
  use QiibeeWeb.ConnCase

  alias Qiibee.Accounts
  alias Qiibee.Balances
  alias Qiibee.Coupons
  alias Qiibee.Balances.Balance
  alias Qiibee.Repo

  import Ecto.Query, warn: false
  import Mox

  setup %{conn: conn} do
    {:ok, brand} = Qiibee.Accounts.create_brand()

    {:ok, user} =
      Qiibee.Accounts.create_user(%{
        "name" => Faker.Person.first_name(),
        "email" => Faker.Internet.safe_email(),
        "phone_number" => Faker.Phone.EnUs.phone(),
        "language" => "ENGLISH",
        "brand_id" => brand.id
      })

    {:ok, dt, _} = DateTime.from_iso8601("2024-01-23T23:50:07Z")
    {:ok, utc_datetime_usec} = Ecto.Type.cast(:utc_datetime_usec, dt)

    {:ok, coupon} =
      Qiibee.Coupons.create_redeem_coupon(%{
        "expires_at" => utc_datetime_usec,
        "brand_id" => brand.id,
        "points" => 300
      })

    {:ok, %{conn: conn, user_id: user.id, coupon_code: coupon.code}}
  end

  test "redeem coupon", %{conn: conn, user_id: user_id, coupon_code: coupon_code} do
    expect_producer(user_id)
    expect_credit(user_id)

    conn =
      conn
      |> put_req_header("authorization", "Bearer " <> user_id)
      |> patch(Routes.coupons_path(conn, :redeem_coupon, coupon_code))

    # THEN
    assert response(conn, 204)
    [txn] = Balances.list_transactions(user_id)

    {:ok, user} = Accounts.get_user(user_id)

    assert user.balance.points == 300
    assert txn.reference == coupon_code
    assert txn.points == 300
  end

  defp expect_credit(user_id) do
    expect(BlockchainMock, :credit, 1, fn ^user_id, points ->
      query = from(w in Balance, where: w.user_id == ^user_id)
      Repo.update_all(query, inc: [points: points])
      Ecto.UUID.generate()
    end)
  end

  defp expect_producer(_user_id) do
    expect(ProducerMock, :dispatch, 1, fn event ->
      data = Jason.decode!(event)
      Coupons.redeem_coupon(data["user_id"], data["code"])
    end)
  end
end
