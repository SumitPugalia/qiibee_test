defmodule QiibeeWeb.Brand.AccountsController do
    use QiibeeWeb, :controller
  
    action_fallback QiibeeWeb.FallbackController
    alias Qiibee.Accounts
    alias Qiibee.Wallets

    def balance(conn, %{"user_id" => user_id} = _params) do
        brand = conn.assigns.current_brand
        with {:ok, user} <- Accounts.get_user_for_brand(user_id, brand.id) do
            render(conn, "balance.json", user: user)
        end
    end
end
