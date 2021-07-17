defmodule Qiibee.Accounts.Brand do
    @moduledoc """
    The Brand model.
    """
  
    use Ecto.Schema
    import Ecto.Changeset
  
    @required_fields ~w(api_key)a
    
    @primary_key {:id, :binary_id, autogenerate: true}
    schema "brands" do
      field :api_key, :string, virtual: true
      field :api_key_hash, :string, unique: true
  
      timestamps()
    end
  
    def changeset(user, attrs) do
      user
      |> cast(attrs, @required_fields)
      |> validate_required(@required_fields)
      |> put_api_key_hash()
      |> unique_constraint(:api_key_hash)
    end

    #############################################################
    # PRIVATE FUNCTIONS
    #############################################################

    defp put_api_key_hash(
         %Ecto.Changeset{valid?: true, changes: %{api_key: api_key}} = changeset
       ) do
      put_change(changeset, :api_key_hash, hashed_api_key(api_key))
    end

    defp put_api_key_hash(changeset) do
      changeset
    end

    defp hashed_api_key(nil) do
      nil
    end

    defp hashed_api_key(api_key) do
      Bcrypt.hash_pwd_salt(api_key)
    end
  end