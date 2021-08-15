defmodule Qiibee.Notifications.StubClient do

    @behaviour Qiibee.Notifications
    alias Qiibee.Notifications
    def send_email(user, reward) do
      IO.inspect(
        "Hi #{user.name},\n You have successfully utilised #{reward.points} to get #{
          reward.description
        }.Your code is #{reward.code}"
      )
  
      :ok
    end
  end