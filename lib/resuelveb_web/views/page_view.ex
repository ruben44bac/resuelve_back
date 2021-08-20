defmodule ResuelvebWeb.PageView do
  use ResuelvebWeb, :view

  def order_levels(levels) do
    levels
    |> Enum.sort(&(&1.value < &2.value))
  end

  def render_sections(template, assigns) do
    render(ResuelvebWeb.PageView, template, assigns)
  end
end
