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
      form_valid?: init_form_validate(),
      new_level: init_new_level(),
      edit: nil,
      levels: LevelHandler.get_levels(),
      result: nil
    )}
  end

  def handle_event("change_json", params, socket) do
    target = params["_target"] |> List.first()
    update = params |> Map.get(target)
    form_valid = socket.assigns.form_valid?
      |> FormHandler.validate_form(target, update)
    form = socket.assigns.form |> update_form(target, update)
    {:noreply, assign(socket, form: form, form_valid?: form_valid)}
  end

  def handle_event("submit_json", params, socket) do
    valid? = params
      |> Map.to_list()
      |> validate_all_form(socket.assigns.form_valid?)
    valid?
      |> Map.to_list()
      |> FormHandler.validate_all_form(true)
      |> case do
        false -> {:noreply, assign(socket, form_valid?: valid?)}
        true -> calculate(socket)
      end
  end

  def handle_event("add_level", _params, socket) do
    new_level = socket.assigns.new_level
    |> Map.put(:show, !socket.assigns.new_level.show)
    {:noreply, assign(socket, new_level: new_level, edit: nil)}
  end

  def handle_event("edit_level", %{"name" => name}, socket) do
    level = socket.assigns.levels
      |> Enum.find(fn l -> l.name == name end)
    new_level = socket.assigns.new_level
    |> Map.put(:show, !socket.assigns.new_level.show)
    |> Map.put(:form, init_form_level(level))
    {:noreply, assign(socket, new_level: new_level, edit: level)}
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
        true -> if socket.assigns.edit != nil,
          do: socket.assigns.new_level.form |> update?(socket),
          else: socket.assigns.new_level.form |> new?(socket)
      end
  end

  defp calculate(socket) do
    result = socket.assigns.form.json
    |> LevelHandler.calculate(socket.assigns.levels)
    {:noreply, assign(socket, result: result)}
  end

  defp update?(form, socket) do
    levels = socket.assigns.levels
    |> List.delete(socket.assigns.edit)
    levels
    |> Enum.find(fn l -> l.name == form.name end)
    |> exist_level?(form, levels, socket)
  end

  defp new?(form, socket) do
    socket.assigns.levels
      |> Enum.find(fn l -> l.name == form.name end)
      |> exist_level?(form, socket.assigns.levels, socket)
  end

  defp exist_level?(nil, form, levels, socket) do
    form = form
      |> Map.put(:value, (form.value |> String.to_integer))
    levels = levels ++ [form]
    new_level = init_new_level()
    {:noreply, assign(socket, levels: levels, new_level: new_level)}
  end

  defp exist_level?(_val, _form, _levels, socket) do
    new_level = socket.assigns.new_level
      |> Map.put(:duplicate, true)
    {:noreply, assign(socket, new_level: new_level)}
  end

  defp init_form() do
    Map.new
      |> Map.put(:json, "")
  end

  defp init_form_validate() do
    %{}
      |> Map.put(:json, %{valid?: true,
        required: [
          %{func: &Resuelveb.FormHandler.json/1, message: "El Json es inválido"},
          %{func: &Resuelveb.FormHandler.required/1, message: "El valor es requerido"}
        ],
        message: ""})
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

  defp init_form_level(level) do
    %{}
      |> Map.put(:name, level.name)
      |> Map.put(:value, level.value |> Integer.to_string)
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
