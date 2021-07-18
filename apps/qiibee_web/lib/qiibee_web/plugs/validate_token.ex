defmodule QiibeeWeb.Plugs.ValidateToken do
  @moduledoc """
  Authenticate the bearer token.
  """

  @behaviour Plug

  import Plug.Conn
  import Phoenix.Controller
  alias Qiibee.Accounts

  @impl Plug
  def init(opts), do: opts

  @impl Plug
  def call(conn, _) do
    with {:ok, token} <- fetch_token(conn),
         {:ok, user} <- Accounts.validate_user(token) do
      conn
      |> assign(:current_user, user)
    else
      {:error, :bearer_token_not_found} ->
        msg = "Bearer Token Not Found"
        send_error(conn, msg)

      _ ->
        msg = "Invalid Token"
        send_error(conn, msg)
    end
  end

  defp send_error(conn, msg) do
    conn
    |> put_status(:unauthorized)
    |> put_view(QiibeeWeb.ErrorView)
    |> render("401.json", message: msg)
    |> halt
  end

  defp fetch_token(conn) do
    case get_req_header(conn, "authorization") do
      ["Bearer " <> token] ->
        {:ok, token}

      _ ->
        {:error, :bearer_token_not_found}
    end
  end
end
