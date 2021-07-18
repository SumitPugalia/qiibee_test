defmodule QiibeeWeb.Router do
  use QiibeeWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :validate_token do
    plug QiibeeWeb.Plugs.ValidateToken
  end

  pipeline :validate_api_key do
    plug QiibeeWeb.Plugs.ValidateApiKey
  end

  scope "/api" do
    pipe_through :api

    scope "/users", QiibeeWeb.User do
      post "/register", AccountsController, :register
    end

    scope "/users", QiibeeWeb.User do
      pipe_through :validate_token

      patch "/redeem_coupon/:code", CouponsController, :redeem_coupon
      patch "/redeem_reward/:id", CouponsController, :redeem_reward
      get "/transaction_history", TransactionsController, :history
    end

    # scope "/brand/users/:user_id", QiibeeWeb.Brand do
    #   pipe_through :validate_api_key

    #   # get "/balance", AccountsController, :balance
    #   # patch "/:points/add_points", AccountsController, :add_points
    #   # patch "/:points/deduct_points", AccountsController, :deduct_points
    #   # get "/transaction_history", TransactionController, :history

    # end
  end
end
