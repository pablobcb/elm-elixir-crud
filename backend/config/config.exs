# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :backend, Backend.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "Bz/4Aq+IHfDAMwT1kpqTVAleXW0mI5B4mGzFQGuXedHvv0bndaPs/6pGovo7p5xI",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: Backend.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# Configure phoenix generators
config :phoenix, :generators,
  migration: true,
  binary_id: false

# Guardian is used for JWT
config :guardian, Guardian,
  allowed_algos: ["HS512"], # optional
  verify_module: Guardian.JWT,  # optional
  hooks: GuardianDb,
  issuer: "Backend",
  ttl: { 3, :days },
  verify_issuer: true, # optional
  secret_key: "guardian secret key",
  serializer: Backend.GuardianSerializer

config :guardian_db, GuardianDb,
       repo: Backend.Repo