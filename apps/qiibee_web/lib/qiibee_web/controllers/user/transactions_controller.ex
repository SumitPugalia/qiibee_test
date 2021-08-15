defmodule QiibeeWeb.User.TransactionsController do
  use QiibeeWeb, :controller

  action_fallback QiibeeWeb.FallbackController
  alias Qiibee.Balances

  def history(conn, _params) do
    user = conn.assigns.current_user

    with transactions <- Balances.list_transactions(user.id) do
      render(conn, "list.json", transactions: transactions)
    end
  end
end
