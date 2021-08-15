# Since configuration is shared in umbrella projects, this file
# should only configure the :qiibee application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

config :qiibee,
  ecto_repos: [Qiibee.Repo]

config :qiibee, :producer, client: Qiibee.RabbitmqWorker
import_config "#{Mix.env()}.exs"
