defmodule ResuelvebWeb.PageLive do
  use ResuelvebWeb, :live_view
  alias Resuelveb.{
    LevelHandler,
    FormHandler
  }

  def render(assigns) do
    ResuelvebWeb.PageView.render("index.html", assigns)
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket,
      form: init_form(),
      new_level: init_new_level(),
      levels: LevelHandler.get_levels()
    )}
  end

  def handle_event("add_level", _params, socket) do
    new_level = socket.assigns.new_level
    |> Map.put(:show, !socket.assigns.new_level.show)
    {:noreply, assign(socket, new_level: new_level)}
  end

  def handle_event("change_new_level", params, socket) do
    target = params["_target"] |> List.first()
    update = params |> Map.get(target)
    form_valid = socket.assigns.new_level.form_valid?
      |> FormHandler.validate_form(target, update)
    form = socket.assigns.new_level.form |> update_form(target, update)
    new_level = socket.assigns.new_level
      |> Map.put(:form, form)
      |> Map.put(:form_valid?, form_valid)
      |> Map.put(:duplicate, false)
    {:noreply, assign(socket, new_level: new_level)}
  end

  def handle_event("submit_new_level", params, socket) do
    valid? = params
      |> Map.to_list()
      |> validate_all_form(socket.assigns.new_level.form_valid?)
    new_level = socket.assigns.new_level
      |> Map.put(:form_valid?, valid?)
    valid?
      |> Map.to_list()
      |> FormHandler.validate_all_form(true)
      |> case do
        false -> {:noreply, assign(socket, new_level: new_level)}
        true -> socket.assigns.new_level.form |> new?(socket)
      end
  end

  defp new?(form, socket) do
    socket.assigns.levels
      |> Enum.find(fn l -> l.name == form.name end)
      |> exist_level?(form, socket)
  end

  defp exist_level?(nil, form, socket) do
    form = form
      |> Map.put(:value, (form.value |> String.to_integer))
    levels = socket.assigns.levels ++ [form]
    new_level = init_new_level()
    {:noreply, assign(socket, levels: levels, new_level: new_level)}
  end

  defp exist_level?(_val, _form, socket) do
    new_level = socket.assigns.new_level
      |> Map.put(:duplicate, true)
    {:noreply, assign(socket, new_level: new_level)}
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

  defp init_new_level() do
    Map.new
      |> Map.put(:show, false)
      |> Map.put(:form, init_form_level())
      |> Map.put(:form_valid?, init_form_level_validate())
      |> Map.put(:duplicate, false)
  end

  defp init_form_level() do
    %{}
      |> Map.put(:name, "")
      |> Map.put(:value, "")
  end

  defp init_form_level_validate() do
    %{}
      |> Map.put(:name, %{valid?: true,
        required: [
          %{func: &Resuelveb.FormHandler.init_space/1, message: "El nivel es inválido"},
          %{func: &Resuelveb.FormHandler.required/1, message: "El valor es requerido"}
        ],
        message: ""})
      |> Map.put(:value, %{valid?: true,
        required: [
          %{func: &Resuelveb.FormHandler.only_number/1, message: "El número de goles es inválido"},
          %{func: &Resuelveb.FormHandler.required/1, message: "El valor es requerido"}
        ],
        message: ""})
  end

  defp validate_all_form([{target, value} | others], validators) do
    validators =
      validators
      |> FormHandler.validate_form(target, value)

    validate_all_form(others, validators)
  end

  defp validate_all_form([], validators), do: validators

  defp update_form(form, target, update, _aux \\ "") do
    form
      |> Map.put(
        target |> String.to_atom(),
        update
      )
  end

end
