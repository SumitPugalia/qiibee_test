defmodule Qiibee.Coupons do
  @moduledoc """
  Accounts context.
  """
  alias Qiibee.Coupons.RedeemCoupon
  alias Qiibee.Coupons.RewardCoupon
  alias Qiibee.Balances
  alias Qiibee.Repo
  alias Qiibee.Notifications

  import Ecto.Query

  #############################################################
  # SERVICE LAYER - Coupons
  #############################################################

  @spec create_redeem_coupon(map()) :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def create_redeem_coupon(attrs \\ %{}) do
    attrs = Map.merge(attrs, %{"code" => RedeemCoupon.code_generator()})

    %RedeemCoupon{}
    |> RedeemCoupon.changeset(attrs)
    |> Repo.insert()
  end

  @spec create_reward_coupon(map()) :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def create_reward_coupon(attrs \\ %{}) do
    attrs = Map.merge(attrs, %{"code" => RewardCoupon.code_generator()})

    %RewardCoupon{}
    |> RewardCoupon.changeset(attrs)
    |> Repo.insert()
  end

  def redeem_coupon(user_id, code) do
    with {:ok, code_details} <- fetch_redeem_coupon_details(code),
         :ok <- validate_code_for_user(user_id, code),
         {:ok, _} <- Balances.add_points(user_id, code_details.code, code_details.points) do
      :ok
    end
  end

  def reward_coupon(user_id, id) do
    with {:ok, reward_details} <- fetch_reward_coupon_details(id),
         {:ok, _} <-
           Balances.deduct_points(user_id, reward_details.code, reward_details.points) do
      Notifications.send_email(reward_details)
    end
  end

  defp validate_code_for_user(user_id, code) do
    case Balances.get_by_code_and_user(user_id, code) do
      {:ok, _txn} -> {:error, :already_used}
      {:error, _} -> :ok
    end
  end

  defp fetch_redeem_coupon_details(code) do
    case Repo.one(from c in RedeemCoupon, where: c.code == ^code) do
      nil ->
        {:error, :invalid_code}

      coupon ->
        if expired?(coupon), do: {:error, :coupon_expired}, else: {:ok, coupon}
    end
  end

  defp fetch_reward_coupon_details(id) do
    case Repo.get(RewardCoupon, id) do
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
end
