defmodule QiibeeWeb.User.FallbackController do
    @moduledoc """
    Translates controller action results into valid `Plug.Conn` responses.
  
    See `Phoenix.Controller.action_fallback/1` for more details.
    """
    use QiibeeWeb, :controller
  
    def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
      conn
      |> put_status(:unprocessable_entity)
      |> put_view(QiibeeWeb.ChangesetView)
      |> render("error.json", changeset: changeset)
    end
  
    def call(conn, {:error, reason}) do
      conn
      |> put_status(:bad_request)
      |> put_view(QiibeeWeb.ErrorView)
      |> render(:"400", %{message: reason})
    end
  
    def call(conn, err) do
      conn
      |> put_status(:internal_server_error)
      |> put_view(QiibeeWeb.ErrorView)
      |> render(:"500", %{message: "something went wrong"})
    end
  end
  