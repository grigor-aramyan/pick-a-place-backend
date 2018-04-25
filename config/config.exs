# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :pap_backend,
  namespace: PAPBackend,
  ecto_repos: [PAPBackend.Repo]

# Configures the endpoint
config :pap_backend, PAPBackendWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "7dT324l+UzkKOy1CKD0juOpez3uK85bzIMgm+SBtroKnhzMS6K127++VBvPJuTWu",
  render_errors: [view: PAPBackendWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: PAPBackend.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
