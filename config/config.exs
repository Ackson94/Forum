# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :probase,
  ecto_repos: [Probase.Repo]

# Configures the endpoint
config :probase, ProbaseWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "yD6lRftL8Ial9g7kurbxYhn73BpV/2DQ+BLpqgNzjTJpV6RmyjDpQG9E9vpRb/ZD",
  render_errors: [view: ProbaseWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Probase.PubSub,
  live_view: [signing_salt: "iXupcDbF"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. Th is must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

