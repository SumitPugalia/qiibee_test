defmodule Qiibee.Balances.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "transactions" do
    field :points, :integer
    field :type, Qiibee.Enums.TransactionType
    field :coupon, :string
    field :tx_hash, :string
    belongs_to(:user, Qiibee.Accounts.User, type: :binary_id)
    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:points, :type, :coupon, :user_id, :tx_hash])
    |> validate_required([:points, :type, :coupon, :user_id, :tx_hash])
    |> assoc_constraint(:user)
  end
end
