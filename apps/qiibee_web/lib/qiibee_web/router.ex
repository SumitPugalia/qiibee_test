defmodule QiibeeWeb.Router do
  use QiibeeWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", QiibeeWeb do
    pipe_through :api
  end
end
