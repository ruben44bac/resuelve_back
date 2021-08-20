defmodule Resuelveb.LevelHandler do

  def get_levels() do
    [
      Map.new
      |> Map.put(:name, "A")
      |> Map.put(:value, 5),
      Map.new
      |> Map.put(:name, "B")
      |> Map.put(:value, 10),
      Map.new
      |> Map.put(:name, "C")
      |> Map.put(:value, 15),
      Map.new
      |> Map.put(:name, "Cuauh")
      |> Map.put(:value, 20),
    ]
  end


end
