# Since configuration is shared in umbrella projects, this file
# should only configure the :qiibee application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

# Configure your database
config :qiibee, Qiibee.Repo,
  username: "postgres",
  password: "postgres",
  database: "qiibee_dev",
  hostname: "localhost",
  pool_size: 10

config :qiibee, :notifications, client: Qiibee.Notifications.StubClient
config :qiibee, :blockchain, client: Qiibee.Blockchain.StubClient
