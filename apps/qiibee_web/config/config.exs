# Since configuration is shared in umbrella projects, this file
# should only configure the :qiibee_web application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

# General application configuration
config :qiibee_web,
  ecto_repos: [Qiibee.Repo],
  generators: [context_app: :qiibee, binary_id: true]

# Configures the endpoint
config :qiibee_web, QiibeeWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "6olddUtnKnUwi8rgwF5MLGY3x4NP/9au6mTD5OAVPURKm1OzjU3SLofp3eexJn2a",
  render_errors: [view: QiibeeWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: QiibeeWeb.PubSub, adapter: Phoenix.PubSub.PG2]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
