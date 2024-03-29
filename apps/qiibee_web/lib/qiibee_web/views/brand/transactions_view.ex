defmodule QiibeeWeb.Brand.TransactionsView do
  use QiibeeWeb, :view

  ## user render_many
  def render("list.json", %{transactions: transactions}) do
    Enum.map(transactions, fn transaction ->
      %{
        id: transaction.id,
        reference: transaction.reference,
        type: transaction.type,
        points: transaction.points,
        tx_hash: transaction.tx_hash
      }
    end)
  end
end
