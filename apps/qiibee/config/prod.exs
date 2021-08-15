# Since configuration is shared in umbrella projects, this file
# should only configure the :qiibee application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

import_config "prod.secret.exs"

config :qiibee, :notifications, client: Qiibee.Notifications.StubClient
config :qiibee, :blockchain, client: Qiibee.Blockchain.StubClient
