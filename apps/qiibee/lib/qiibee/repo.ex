defmodule Qiibee.Repo do
  use Ecto.Repo,
    otp_app: :qiibee,
    adapter: Ecto.Adapters.Postgres
end
