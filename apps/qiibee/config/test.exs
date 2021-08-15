# Since configuration is shared in umbrella projects, this file
# should only configure the :qiibee application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

# Configure your database
config :qiibee, Qiibee.Repo,
  username: "postgres",
  password: "postgres",
  database: "qiibee_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :qiibee, :blockchain, client: BlockchainMock
config :qiibee, :producer, client: ProducerMock
