defmodule QiibeeWeb.Brand.AccountsView do
    use QiibeeWeb, :view
  
    def render("balance.json", %{user: user}) do
      %{
        points: user.balance.points
      }
    end
  end
  