defmodule Qiibee.AccountsTest do
  use Qiibee.DataCase

  alias Qiibee.Accounts
  alias Qiibee.Accounts.Brand
  alias Qiibee.Accounts.User

  describe "brand" do
    test "create_brand/1 successfully creates new brand" do
      {:ok, %Brand{} = brand} = Accounts.create_brand()
      assert is_binary(brand.api_key)
      assert is_binary(brand.id)
    end
  end

  describe "user" do
    test "create_user/1 successfully creates new user with wallet" do
      {:ok, %Brand{} = brand} = Accounts.create_brand()

      user_params =
        user_params()
        |> Map.put("brand_id", brand.id)

      {:ok, %User{} = user} = Qiibee.Accounts.create_user(user_params)

      assert is_binary(user.id)
      assert is_binary(user.wallet.id)
      assert user.wallet.points == 0
    end

    test "create_user/1 fails to create new user with missing params" do
      {:ok, %Brand{} = brand} = Accounts.create_brand()

      user_params =
        user_params()
        |> Map.put("brand_id", brand.id)

      Enum.each([:name, :email, :phone_number, :language], fn k ->
        user_params = Map.delete(user_params, Atom.to_string(k))
        {:error, cs_error} = Qiibee.Accounts.create_user(user_params)
        assert cs_error.errors[k] == {"can't be blank", [validation: :required]}
      end)
    end

    test "create_user/1 fails to create new user with unknown brand id" do
      user_params =
        user_params()
        |> Map.put("brand_id", Ecto.UUID.generate())

      {:error, cs_error} = Qiibee.Accounts.create_user(user_params)

      assert cs_error.errors == [
               brand:
                 {"does not exist", [constraint: :assoc, constraint_name: "users_brand_id_fkey"]}
             ]
    end

    defp user_params() do
      %{
        "name" => "Sumit",
        "email" => "sumit@yahoo.com",
        "phone_number" => "9582557758",
        "language" => "US"
      }
    end
  end
end
