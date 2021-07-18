defmodule Qiibee.Accounts do
  @moduledoc """
  Accounts context.
  """
  alias Qiibee.Accounts.Brand
  alias Qiibee.Accounts.User
  alias Qiibee.Repo

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

  #############################################################
  # SERVICE LAYER - USERS
  #############################################################

  @spec create_user(map()) :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def create_user(attrs \\ %{}) do
    wallet = %{"points" => 0}
    attrs = Map.put_new(attrs, "wallet", wallet)

    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, user} ->
        {:ok, Repo.preload(user, [:wallet])}

      error ->
        error
    end
  end

  def validate_user(token) do
    {:ok, Repo.get(User, token) |> Repo.preload([:wallet])}
  end

  #############################################################
  # PRIVATE FUNCTIONS
  #############################################################
  defp generate_api_key() do
    Ecto.UUID.generate()
  end
end
