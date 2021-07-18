defmodule QiibeeWeb.User.TransactionsController do
  use QiibeeWeb, :controller

  action_fallback QiibeeWeb.User.FallbackController
  alias Qiibee.Wallets

  def history(conn, _params) do
    user = conn.assigns.current_user

    with transactions <- Wallets.list_transactions(user) do
      render(conn, "list.json", transactions: transactions)
    end
  end
end
