defmodule Qiibee.Coupons.Reward do
	use Ecto.Schema
	import Ecto.Changeset

	@primary_key {:id, :binary_id, autogenerate: true}
	schema "rewards" do
		field :code, :string, unique: true
		field :description, :string

		timestamps()
	end

	@doc false
	def changeset(coupon, attrs) do
		coupon
		|> cast(attrs, [:code, :description])
		|> validate_required([:code, :description])
	end

	def code_generator() do
		for _ <- 1..10, into: "", do: <<Enum.random(?a..?z)>>
	end
end
  