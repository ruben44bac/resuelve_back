defmodule ResuelvebWeb.PageLive do
  use ResuelvebWeb, :live_view
  alias Resuelveb.LevelHandler

  def mount(_params, _session, socket) do
    {:ok, assign(socket,
      form: init_form(),
      levels: LevelHandler.get_levels()
    )}
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
end
