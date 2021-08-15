defmodule QiibeeWeb.Brand.TransactionsView do
    use QiibeeWeb, :view
  
    ## user render_many
    def render("list.json", %{transactions: transactions}) do
      Enum.map(transactions, fn transaction ->
        %{
          id: transaction.id,
          code: transaction.coupon,
          type: transaction.type,
          points: transaction.points
        }
      end)
    end
  end
  