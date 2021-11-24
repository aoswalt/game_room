use Mix.Config

config :game_room, GameRoomWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "3ssMhx8HdBwiUMnTmFlvgfForXGYk+EZdZ6x7o8yqYCV27FSpqN0z0fDWk5ukKcK",
  render_errors: [view: GameRoomWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: GameRoom.PubSub,
  live_view: [signing_salt: "LsTSfUEQ"]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
