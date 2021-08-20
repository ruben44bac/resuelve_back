defmodule ResuelvebWeb.PageLive do
  use ResuelvebWeb, :live_view
  alias Resuelveb.{
    LevelHandler
  }

  def render(assigns) do
    ResuelvebWeb.PageView.render("index.html", assigns)
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket,
      form: init_form(),
      form_level: init_form_level(),
      levels: LevelHandler.get_levels()
    )}
  end

  def handle_event("add_level", _params, socket) do
    form_level = socket.assigns.form_level
    |> Map.put(:show, !socket.assigns.form_level.show)
    {:noreply, assign(socket, form_level: form_level)}
  end

  defp init_form() do
    Map.new
    |> Map.put(:error, init_error())
  end

  defp init_error() do
    Map.new
    |> Map.put(:status, false)
    |> Map.put(:message, "")
  end

  defp init_form_level() do
    Map.new
    |> Map.put(:show, false)
  end

end
