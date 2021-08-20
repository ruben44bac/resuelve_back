defmodule ResuelvebWeb.PageController do
  use ResuelvebWeb, :controller
  alias Phoenix.LiveView

  def index(conn, _params) do
    conn
      |> LiveView.Controller.live_render(ResuelvebWeb.PageLive, session: %{})
  end

end
