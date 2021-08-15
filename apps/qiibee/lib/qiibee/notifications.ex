defmodule Qiibee.Notifications do
    alias Qiibee.Accounts.User
    alias Qiibee.Coupons.RewardCoupon
    @callback send_email(%User{}, %RewardCoupon{}) :: :ok

    @spec  send_email(User.t(), RewardCoupon.t()) :: :ok
    def send_email(user, reward_coupon) do
        client().send_email(user, reward_coupon)
    end

    #############################################################
    # PRIVATE FUNCTIONS
    #############################################################
    defp client() do
        Application.fetch_env!(:qiibee, :notifications)[:client]
    end
end