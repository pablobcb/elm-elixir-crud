use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :backend, Backend.Endpoint,
  http: [port: 8081],
  server: false

config :logger, level: :warn
#config :logger, :console, format: "[$level] $message\n"

# Configure your database
config :backend, Backend.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "backend_dev",
  password: "backend_dev",
  database: "backend_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
