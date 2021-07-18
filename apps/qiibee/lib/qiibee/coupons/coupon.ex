defmodule Qiibee.Coupons.Coupon do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "coupons" do
    field :code, :string, unique: true
    field :expires_at, :utc_datetime_usec
    field :points, :integer
    belongs_to(:brand, Qiibee.Accounts.Brand, type: :binary_id)
    timestamps()
  end

  @doc false
  def changeset(coupon, attrs) do
    coupon
    |> cast(attrs, [:code, :expires_at, :brand_id, :points])
    |> validate_required([:code, :expires_at, :brand_id, :points])
    |> assoc_constraint(:brand)
  end

  def code_generator() do
    for _ <- 1..9, into: "", do: <<Enum.random(Enum.concat([?0..?9, ?A..?Z, ?a..?z]))>>
  end
end
