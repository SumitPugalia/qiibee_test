defmodule Qiibee.Blockchain.StubClient do
  @behaviour Qiibee.Blockchain

  alias Qiibee.Blockchain
  alias Qiibee.Balances.Balance
  alias Qiibee.Repo

  import Ecto.Query, warn: false

  @impl Blockchain
  def credit(user_id, points) do
    query = from(w in Balance, where: w.user_id == ^user_id)
    Repo.update_all(query, inc: [points: points])
    # tx hash
    Ecto.UUID.generate()
  end

  @impl Blockchain
  def debit(user_id, points) do
    query = from(w in Balance, where: w.user_id == ^user_id and w.points >= ^points)
    points = -1 * points

    Repo.update_all(query, inc: [points: points])
    # tx hash
    Ecto.UUID.generate()
  end
end
