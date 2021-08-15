defmodule Qiibee.Accounts do
  @moduledoc """
  Accounts context.
  """
  alias Qiibee.Accounts.Brand
  alias Qiibee.Accounts.User
  alias Qiibee.Repo

  import Ecto.Query, warn: false

  #############################################################
  # SERVICE LAYER - BRANDS
  #############################################################

  @spec create_brand(map()) :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def create_brand(attrs \\ %{}) do
    attrs = Map.put(attrs, :api_key, generate_api_key())

    %Brand{}
    |> Brand.changeset(attrs)
    |> Repo.insert()
  end

  def get_brand_by_api_key(api_key) do
    case Repo.one(from b in Brand, where: b.api_key == ^api_key) do
      nil ->
        {:error, :brand_not_found}

      brand ->
        {:ok, brand}
    end
  end

  def validate_brand(api_key) do
    get_brand_by_api_key(api_key)
  end

  #############################################################
  # SERVICE LAYER - USERS
  #############################################################

  @spec create_user(map()) :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def create_user(attrs \\ %{}) do
    balance = %{"points" => 0}
    attrs = Map.put_new(attrs, "balance", balance)

    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, user} ->
        {:ok, Repo.preload(user, [:balance])}

      error ->
        error
    end
  end

  def get_user(id) do
    User
    |> Repo.get(id)
    |> case do
      nil ->
        {:error, :not_found}

      user ->
        {:ok, Repo.preload(user, [:balance])}
    end
  end

  def get_user_for_brand(user_id, brand_id) do
    case Repo.one(from u in User, where: u.id == ^user_id and u.brand_id == ^brand_id) do
      nil ->
        {:error, :user_not_found}

      user ->
        {:ok, Repo.preload(user, [:balance])}
    end
  end

  def validate_user(token) do
    get_user(token)
  end

  #############################################################
  # PRIVATE FUNCTIONS
  #############################################################
  defp generate_api_key() do
    Ecto.UUID.generate()
  end
end
