defmodule ResuelvebWeb.PageView do
  use ResuelvebWeb, :view

  def order_levels(levels) do
    levels
    |> Enum.sort(&(&1.value < &2.value))
  end
end
