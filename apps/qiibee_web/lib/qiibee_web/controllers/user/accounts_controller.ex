defmodule QiibeeWeb.User.AccountsController do
  use QiibeeWeb, :controller

  action_fallback QiibeeWeb.FallbackController
  alias Qiibee.Accounts

  def register(conn, params) do
    with {:ok, user} <- Accounts.create_user(params) do
      render(conn, "register.json", user: user)
    end
  end
end
