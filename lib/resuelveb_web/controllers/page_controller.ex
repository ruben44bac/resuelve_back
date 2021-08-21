defmodule ResuelvebWeb.PageController do
  use ResuelvebWeb, :controller
  alias Phoenix.LiveView

  @spec index(Plug.Conn.t(), any) :: Plug.Conn.t()
  def index(conn, _params) do
    conn
      |> LiveView.Controller.live_render(ResuelvebWeb.PageLive, session: %{})
  end

end
