defmodule Qiibee.Notifications do
  alias Qiibee.Coupons.RewardCoupon
  @callback send_email(%RewardCoupon{}) :: :ok

  @spec send_email(RewardCoupon.t()) :: :ok
  def send_email(reward_coupon) do
    client().send_email(reward_coupon)
  end

  #############################################################
  # PRIVATE FUNCTIONS
  #############################################################
  defp client() do
    Application.fetch_env!(:qiibee, :notifications)[:client]
  end
end
