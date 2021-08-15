defmodule Qiibee.Notifications.StubClient do

    @behaviour Qiibee.Notifications
    
    def send_email(reward) do
      IO.inspect(
        "You have successfully utilised #{reward.points} to get #{
          reward.description
        }.Your code is #{reward.code}"
      )
  
      :ok
    end
  end