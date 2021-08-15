defmodule QiibeeWeb.Brand.AccountsController do
    use QiibeeWeb, :controller
  
    action_fallback QiibeeWeb.FallbackController
    alias Qiibee.Accounts
    alias Qiibee.Balances

    def balance(conn, %{"user_id" => user_id} = _params) do
        brand = conn.assigns.current_brand
        with {:ok, user} <- Accounts.get_user_for_brand(user_id, brand.id) do
            render(conn, "balance.json", user: user)
        end
    end

    def add_points(conn, %{"user_id" => user_id, "points" => points} = _params) do
        brand = conn.assigns.current_brand
        with {points, _} <-  Integer.parse(points),
            {:ok, user} <- Accounts.get_user_for_brand(user_id, brand.id),
            :ok <- Balances.add_points(user.id, "ManuallyAddedByBrand", points) do
                send_resp(conn, 204, "")
        end
    end

    def deduct_points(conn, %{"user_id" => user_id, "points" => points} = _params) do
        brand = conn.assigns.current_brand
        with {points, _} <-  Integer.parse(points), 
            {:ok, user} <- Accounts.get_user_for_brand(user_id, brand.id),
            :ok <- Balances.deduct_points(user.id, "ManuallyDeductedByBrand", points) do
                send_resp(conn, 204, "")
        end
    end
end
