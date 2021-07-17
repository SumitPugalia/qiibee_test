defmodule Qiibee.Accounts.User do
  @moduledoc """
  The User model.
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias Qiibee.Accounts.Brand
  alias Qiibee.Wallets.Wallet

  @required_fields ~w(name email phone_number language brand_id)a

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "users" do
    field(:name, :string)
    field(:email, :string)
    field(:phone_number, :string)
    field(:language, :string)
    belongs_to(:brand, Brand, type: :binary_id)

    has_one :wallet, Wallet
    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:brand)
    |> unique_constraint([:name, :brand_id])
    |> unique_constraint([:email, :brand_id])
    |> unique_constraint([:phone_number, :brand_id])
    |> cast_assoc(:wallet, with: &Wallet.changeset/2, required: true)
  end
end
