defmodule QiibeeWeb.Brand.AccountsController do
  use QiibeeWeb, :controller

  action_fallback QiibeeWeb.FallbackController
  alias Qiibee.Accounts

  def balance(conn, %{"user_id" => user_id} = _params) do
    brand = conn.assigns.current_brand

    with {:ok, user} <- Accounts.get_user_for_brand(user_id, brand.id) do
      render(conn, "balance.json", user: user)
    end
  end

  def add_points(conn, %{"user_id" => user_id, "points" => points} = _params) do
    brand = conn.assigns.current_brand

    with {points, _} <- Integer.parse(points),
         {:ok, user} <- Accounts.get_user_for_brand(user_id, brand.id) do
      data = Jason.encode!(%{user_id: user.id, points: points, event: "earn_points"})
      Qiibee.Producer.dispatch(data)
      send_resp(conn, 204, "")
    end
  end

  def deduct_points(conn, %{"user_id" => user_id, "points" => points} = _params) do
    brand = conn.assigns.current_brand

    with {points, _} <- Integer.parse(points),
         {:ok, user} <- Accounts.get_user_for_brand(user_id, brand.id) do
      data = Jason.encode!(%{user_id: user.id, points: points, event: "burn_points"})
      Qiibee.Producer.dispatch(data)
      send_resp(conn, 204, "")
    end
  end
end
