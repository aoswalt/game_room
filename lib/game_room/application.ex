defmodule GameRoom.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    store_game_slug_mapping()

    children = [
      # Start the Telemetry supervisor
      GameRoomWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: GameRoom.PubSub},
      # Start the Endpoint (http/https)
      GameRoomWeb.Endpoint,
      # Start a worker by calling: GameRoom.Worker.start_link(arg)
      # {GameRoom.Worker, arg}
      {Registry, keys: :unique, name: GameRegistry}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: GameRoom.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    GameRoomWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  def store_game_slug_mapping() do
    mapping =
      for module <- GameRoom.list_game_modules(), into: %{} do
        slug = module.slug()
        {slug, module}
      end

    :persistent_term.put(:slug_mapping, mapping)
  end
end
