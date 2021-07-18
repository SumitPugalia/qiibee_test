defmodule Qiibee.Coupons do
  @moduledoc """
  Accounts context.
  """
  alias Qiibee.Coupons.Coupon
  alias Qiibee.Coupons.Reward
  alias Qiibee.Wallets
  alias Qiibee.Repo

  import Ecto.Query

  #############################################################
  # SERVICE LAYER - Coupons
  #############################################################

  @spec create_coupon(map()) :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def create_coupon(attrs \\ %{}) do
    attrs = Map.merge(attrs, %{"code" => Coupon.code_generator()})

    %Coupon{}
    |> Coupon.changeset(attrs)
    |> Repo.insert()
  end

  @spec create_reward(map()) :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def create_reward(attrs \\ %{}) do
    attrs = Map.merge(attrs, %{"code" => Reward.code_generator()})

    %Reward{}
    |> Reward.changeset(attrs)
    |> Repo.insert()
  end

  def redeem_coupon(user, code) do
    with {:ok, code_details} <- fetch_coupon_details(code),
         :ok <- validate_code_for_user(user.wallet.id, code),
         {:ok, _} <- Wallets.add_points(user.wallet, code_details.code, code_details.points) do
      :ok
    end
  end

  def redeem_reward(user, id) do
    with {:ok, reward_details} <- fetch_reward_details(id),
         {:ok, _} <-
           Wallets.deduct_points(user.wallet, reward_details.code, reward_details.points) do
      notify().send_email(user, reward_details)
    end
  end

  defp validate_code_for_user(wallet_id, code) do
    case Wallets.get_by_code_and_user(wallet_id, code) do
      {:ok, _txn} -> {:error, :already_used}
      {:error, _} -> :ok
    end
  end

  defp fetch_coupon_details(code) do
    case Repo.one(from c in Coupon, where: c.code == ^code) do
      nil ->
        {:error, :invalid_code}

      coupon ->
        if expired?(coupon), do: {:error, :coupon_expired}, else: {:ok, coupon}
    end
  end

  defp fetch_reward_details(id) do
    case Repo.get(Reward, id) do
      nil -> {:error, :invalid_code}
      reward -> {:ok, reward}
    end
  end

  defp expired?(coupon) do
    case DateTime.compare(coupon.expires_at, DateTime.utc_now()) do
      :gt -> false
      :lt -> true
    end
  end

  ## Use Adapter Pattern to pick required module
  defp notify() do
    Application.fetch_env!(:qiibee, :notifications)[:email]
  end
end
