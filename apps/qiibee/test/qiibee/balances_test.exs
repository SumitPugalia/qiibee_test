defmodule Qiibee.BalancesTest do
    use Qiibee.DataCase
    alias Qiibee.Balances
    alias Qiibee.Accounts
    alias Qiibee.Balances.Balance
    alias Qiibee.Repo

    import Ecto.Query, warn: false
    import Mox
    
    setup do
        {:ok, brand1} = Qiibee.Accounts.create_brand()

        {:ok, user} =
            Qiibee.Accounts.create_user(%{
                "name" => Faker.Person.first_name(),
                "email" => Faker.Internet.safe_email(),
                "phone_number" => Faker.Phone.EnUs.phone(),
                "language" => "ENGLISH",
                "brand_id" => brand1.id
            })
        {:ok, %{user_id: user.id}}
    end

    test "success for add_points", %{user_id: user_id} do
        # GIVEN
        expect_credit(user_id)

        # WHEN
        :ok = Balances.add_points(user_id, "ManuallyAddedByBrand", 100)
        [txn] = Balances.list_transactions(user_id)
        
        # THEN
        {:ok, user} = Accounts.get_user(user_id)

        assert user.balance.points == 100
        assert txn.reference == "ManuallyAddedByBrand"
        assert txn.points == 100
    end

    test "fails for deduct_points with insufficient funds", %{user_id: user_id} do
        # GIVEN
        expect_debit(user_id)

        # WHEN
        {:error, :insufficient_balance} = Balances.deduct_points(user_id, "ManuallyDeductedByBrand", 100)
        
        # THEN
        assert [] == Balances.list_transactions(user_id)
    end

    test "success for deduct_points", %{user_id: user_id} do
        # GIVEN
        expect_credit(user_id)
        expect_debit(user_id)
        
        :ok = Balances.add_points(user_id, "ManuallyAddedByBrand", 500)

        # WHEN
        :ok = Balances.deduct_points(user_id, "ManuallyDeductedByBrand", 100)
        [txn1, txn2] = Enum.sort(Balances.list_transactions(user_id))
        
        # THEN
        {:ok, user} = Accounts.get_user(user_id)

        assert user.balance.points == 400
        if txn1.reference == "ManuallyDeductedByBrand" do
            assert txn1.points == 100
            assert txn2.points == 500
        else
            assert txn1.points == 500 
            assert txn2.points == 100
        end
    end

    defp expect_credit(user_id) do
        expect(BlockchainMock, :credit, 1, fn ^user_id, points ->
            query = from(w in Balance, where: w.user_id == ^user_id)
            Repo.update_all(query, inc: [points: points])
            Ecto.UUID.generate()
        end)
    end

    defp expect_debit(user_id) do
        expect(BlockchainMock, :debit, 1, fn ^user_id, points ->
            query = from(w in Balance, where: w.user_id == ^user_id and w.points >= ^points)
            points = -1 * points

            Repo.update_all(query, inc: [points: points])
            Ecto.UUID.generate()
        end)
    end
end