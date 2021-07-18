defmodule QiibeeWeb.Brand.AccountsView do
    use QiibeeWeb, :view
  
    def render("balance.json", %{user: user}) do
      %{
        points: user.wallet.points
      }
    end
  end
  