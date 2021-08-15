defmodule QiibeeWeb.User.CouponsController do
  use QiibeeWeb, :controller

  action_fallback QiibeeWeb.FallbackController
  alias Qiibee.Coupons

  def redeem_coupon(conn, %{"code" => code} = params) do
    user = conn.assigns.current_user
    data = Jason.encode!(%{user_id: user.id, code: code, event: "code_to_points"})
    Qiibee.Producer.dispatch(data)
    send_resp(conn, :no_content, "")

  end

  def redeem_point(conn, %{"reward_coupon_id" => id} = params) do
    user = conn.assigns.current_user
    data = Jason.encode!(%{user_id: user.id, id: id, event: "points_to_reward"})
    Qiibee.Producer.dispatch(data)
    send_resp(conn, :no_content, "")

  end
end
