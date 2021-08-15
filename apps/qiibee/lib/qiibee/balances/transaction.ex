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
    |> cast(attrs, [:points, :type, :reference_code, :user_id])
    |> validate_required([:points, :type, :reference_code, :user_id])
    |> assoc_constraint(:balance)
  end
end
