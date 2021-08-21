defmodule ResuelvebWeb.PageView do
  use ResuelvebWeb, :view

  @spec order_levels(any) :: list
  def order_levels(levels) do
    levels
    |> Enum.sort(&(&1.value < &2.value))
  end

  @spec render_sections(any, any) :: any
  def render_sections(template, assigns) do
    render(ResuelvebWeb.PageView, template, assigns)
  end
end
