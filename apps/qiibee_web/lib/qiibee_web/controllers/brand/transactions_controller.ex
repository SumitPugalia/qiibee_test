defmodule QiibeeWeb.Brand.TransactionsController do
    use QiibeeWeb, :controller
  
    action_fallback QiibeeWeb.FallbackController
    alias Qiibee.Accounts
    alias Qiibee.Balances
  
    def history(conn, %{"user_id" => user_id} = _params) do
      brand = conn.assigns.current_brand
        
      with {:ok, user} <- Accounts.get_user_for_brand(user_id, brand.id),
        transactions <- Balances.list_transactions(user) do
        render(conn, "list.json", transactions: transactions)
      end
    end
  end
