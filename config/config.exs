# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :kube_proj,
  ecto_repos: [KubeProj.Repo]

# Configures the endpoint
config :kube_proj, KubeProjWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "t5h5edMGgPNImjWnx4MBbT3rnmV5BsvoxLHXDY3vJzlGrv0NqEbXZO5l0UYSuT6Z",
  render_errors: [view: KubeProjWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: KubeProj.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
