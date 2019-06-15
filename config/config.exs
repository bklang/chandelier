# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :chandelier, ChandelierWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "okuo1XTKmqfS0jFUe7tA8kzi+52BCANAB3YSBJnYZPBRqQ9P80EYnH5vrgxUqhR/",
  render_errors: [view: ChandelierWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Chandelier.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
