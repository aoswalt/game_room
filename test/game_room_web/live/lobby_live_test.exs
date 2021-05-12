defmodule GameRoomWeb.LobbyLiveTest do
  use GameRoomWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, lobby_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "Welcome to Phoenix!"
    assert render(lobby_live) =~ "Welcome to Phoenix!"
  end
end
