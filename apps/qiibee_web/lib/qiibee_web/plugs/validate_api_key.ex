defmodule QiibeeWeb.Plugs.ValidateApiKey do
    @moduledoc """
    Authenticate the bearer api_key.
    """
  
    @behaviour Plug
  
    import Plug.Conn
    import Phoenix.Controller
    alias Qiibee.Accounts
  
    @impl Plug
    def init(opts), do: opts
  
    @impl Plug
    def call(conn, _) do
      with {:ok, api_key} <- fetch_api_key(conn),
           {:ok, brand} <- Accounts.validate_brand(api_key) do
        conn
        |> assign(:current_brand, brand)
      else
        {:error, :api_key_not_found} ->
            msg = "Api Key Not Found"
            send_error(conn, msg)
        _ -> 
            msg = "Invalid API Key"
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
  
    defp fetch_api_key(conn) do
      case get_req_header(conn, "x-api-key") do
        [api_key] when api_key != "" > 0 -> {:ok, api_key}
        _ ->
          {:error, :api_key_not_found}
      end
    end
  end