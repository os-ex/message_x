# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :message_x,
  ecto_repos: [MessageX.Repo]

# Configures the endpoint
config :message_x, MessageXWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "iU5DESFkzgqQWquc4itmuMxTK0jIze6mx3Dwz7TcLC8st6tPyIRFOJa0S60rR0Gx",
  render_errors: [view: MessageXWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: MessageX.PubSub,
  live_view: [signing_salt: "1/+WOhcL"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import chatdb
import_config "libs/chat_db.exs"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
