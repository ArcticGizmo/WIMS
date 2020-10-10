import Config

config :wims,
  ecto_repos: [Wims.Repo]

# Configures the endpoint
config :wims, WimsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "pd7vETifWrWTd8+lw7nr2L4y6wYVSanvjWPwrqeDKAANrX1guOL0YvkPoP+99JTu",
  render_errors: [view: WimsWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Wims.PubSub,
  live_view: [signing_salt: "MXovoymk"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

if File.exists?("config/config.secret.exs") do
  import_config "config.secret.exs"
end
