defmodule Qiibee.Balances.Balance do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "balances" do
    field :points, :integer
    belongs_to(:user, Qiibee.Accounts.User, type: :binary_id)
    timestamps()
  end

  @doc false
  def changeset(balance, attrs) do
    balance
    |> cast(attrs, [:points])
    |> validate_required([:points])
    |> validate_number(:points, greater_than_or_equal_to: 0)
    |> validate_number(:points, less_than: 100_000)
    |> assoc_constraint(:user)
  end
end
