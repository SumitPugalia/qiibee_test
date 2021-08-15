defmodule QiibeeWeb.User.AccountsView do
  use QiibeeWeb, :view

  def render("register.json", %{user: user}) do
    %{
      id: user.id,
      balance_id: user.balance.id,
      points: user.balance.points
    }
  end
end
