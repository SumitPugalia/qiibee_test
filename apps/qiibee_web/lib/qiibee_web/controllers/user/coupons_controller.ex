defmodule QiibeeWeb.User.CouponsController do
  use QiibeeWeb, :controller

  action_fallback QiibeeWeb.FallbackController
  alias Qiibee.Coupons

  def redeem_coupon(conn, %{"code" => code} = params) do
    user = conn.assigns.current_user

    with :ok <- Coupons.redeem_coupon(user, code) do
      send_resp(conn, :no_content, "")
    end
  end

  def redeem_point(conn, %{"reward_coupon_id" => id} = params) do
    user = conn.assigns.current_user

    with :ok <- Coupons.reward_coupon(user, id) do
      send_resp(conn, :no_content, "")
    end
  end
end
