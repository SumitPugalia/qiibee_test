defmodule Qiibee.Notifications.Email.Console do
  ## create behaviour..
  def send_email(user, reward) do
    IO.inspect(
      "Hi #{user.name},\n You have successfully utilised #{reward.points} to get #{
        reward.description
      }.Your code is #{reward.code}"
    )

    :ok
  end
end
