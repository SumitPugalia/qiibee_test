defmodule Qiibee.Accounts.Brand do
  @moduledoc """
  The Brand model.
  """

  use Ecto.Schema
  import Ecto.Changeset

  @required_fields ~w(api_key)a

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "brands" do
    field :api_key, :string, unique: true

    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:api_key)
  end
end
