defmodule Qiibee.Accounts.User do
  @moduledoc """
  The User model.
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias Qiibee.Accounts.Brand
  alias Qiibee.Balances.Balance

  @required_fields ~w(name email phone_number language brand_id)a

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "users" do
    field(:name, :string)
    field(:email, :string)
    field(:phone_number, :string)
    field(:language, :string)
    belongs_to(:brand, Brand, type: :binary_id)

    has_one :balance, Balance
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
    |> cast_assoc(:balance, with: &Balance.changeset/2, required: true)
  end
end
