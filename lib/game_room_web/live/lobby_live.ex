defmodule GameRoomWeb.LobbyLive do
  use GameRoomWeb, :live_view

  @impl true
  def mount(_params, session, socket) do
    {:ok, assign_defaults(session, socket)}
  end

  @impl true
  def handle_event("join", data, socket) do
    module = data["module"] |> String.to_existing_atom()
    slug = module.slug()
    user_id = socket.assigns.user_id
    player = %GameRoom.Player{id: user_id}

    game =
      case GameRoom.Games.list_open_games(module) do
        [] ->
          {:ok, pid} = GameRoom.GameInstance.start(module, player)
          pid

        [{_key, pid, _status}] ->
          GenServer.call(pid, {:add_player, player})
          pid
      end

    id = GenServer.call(game, :id)

    {:noreply, push_redirect(socket, to: Routes.game_path(socket, :show, slug, id))}
  end

  @impl true
  def handle_event("suggest", %{"q" => query}, socket) do
    {:noreply, assign(socket, results: search(query), query: query)}
  end

  @impl true
  def handle_event("search", %{"q" => query}, socket) do
    case search(query) do
      %{^query => vsn} ->
        {:noreply, redirect(socket, external: "https://hexdocs.pm/#{query}/#{vsn}")}

      _ ->
        {:noreply,
         socket
         |> put_flash(:error, "No dependencies found matching \"#{query}\"")
         |> assign(results: %{}, query: query)}
    end
  end

  defp search(query) do
    if not GameRoomWeb.Endpoint.config(:code_reloader) do
      raise "action disabled when not in development"
    end

    for {app, desc, vsn} <- Application.started_applications(),
        app = to_string(app),
        String.starts_with?(app, query) and not List.starts_with?(desc, ~c"ERTS"),
        into: %{},
        do: {app, vsn}
  end
end
