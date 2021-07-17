defmodule Qiibee.Wallets.Transaction do
	use Ecto.Schema
	import Ecto.Changeset

	@primary_key {:id, :binary_id, autogenerate: true}
	schema "transactions" do
		field :points, :integer
		field :type, Qiibee.Enums.TransactionType
		field :reference_code, :string
		belongs_to(:wallet, Qiibee.Wallets.Wallet, type: :binary_id)
		timestamps()
	end

	@doc false
	def changeset(transaction, attrs) do
		transaction
		|> cast(attrs, [:points, :type, :reference_code, :wallet_id])
		|> validate_required([:points, :type, :reference_code, :wallet_id])
		|> assoc_constraint(:wallet)
		|> unique_constraint([:reference_code, :wallet_id])
	end
end
  