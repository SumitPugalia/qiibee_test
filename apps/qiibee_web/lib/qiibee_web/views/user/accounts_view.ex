defmodule QiibeeWeb.User.AccountsView do
  use QiibeeWeb, :view

  def render("register.json", %{user: user}) do
    %{
      id: user.id,
      wallet_id: user.wallet.id,
      points: user.wallet.points
    }
  end
end
