defmodule Resuelveb.LevelHandler do

  @moduledoc """
    This module contains functions related to the calculation of salaries and levels
  """
  @spec get_levels :: [%{name: <<_::8, _::_*32>>, value: 5 | 10 | 15 | 20}, ...]
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

  @spec calculate(
          binary
          | maybe_improper_list(
              binary | maybe_improper_list(any, binary | []) | byte,
              binary | []
            ),
          any
        ) :: %{
          json:
            binary
            | maybe_improper_list(
                binary | maybe_improper_list(any, binary | []) | byte,
                binary | []
              ),
          team: list
        }
  def calculate(data, levels) do
    data = data |> Poison.decode!
    team = data["jugadores"]
    |> Enum.group_by(fn v -> v["equipo"] end)
    |> Enum.map(fn {_k,  v} -> v |> reckoner(levels) end)
    json = team
    |> List.flatten
    |> build_json()
    %{team: team, json: json}
  end

  @spec build_json(any) ::
          binary
          | maybe_improper_list(
              binary | maybe_improper_list(any, binary | []) | byte,
              binary | []
            )
  def build_json(json) do
    %{"jugadores" => json} |> Poison.encode!
  end

  @spec reckoner([map], any) :: [map]
  def reckoner(arr, levels) do
    goal_total_team = arr
    |> get_goal_total_team
    goal_total_team_ideal = arr
    |> get_goal_total_team_ideal(levels)
    total_team = goal_total_team / goal_total_team_ideal
    arr
    |> calcule_individual(total_team, levels, [])
  end

  defp calcule_individual([player | others], total_team, levels, new_arr) do
    total_individual = player["goles"] / (player["nivel"] |> get_levels_value(levels))
    bond = ((total_team + total_individual) / 2) * player["bono"]
    player = player
    |> Map.put("sueldo_completo", bond + player["sueldo"])
    calcule_individual(others, total_team, levels, new_arr ++ [player])
  end

  defp calcule_individual([], _total_team, _levels, new_arr), do: new_arr

  defp get_goal_total_team(arr) do
    arr
    |> Enum.map(fn g -> g["goles"] end)
    |> Enum.sum
  end

  defp get_goal_total_team_ideal(arr, levels) do
    arr
    |> Enum.map(fn g -> g["nivel"] |> get_levels_value(levels) end)
    |> Enum.sum
  end

  defp get_levels_value(name, levels) do
    levels
    |> Enum.find(fn m -> m.name == name end)
    |> case do
      nil -> 10000
      val -> val.value
    end
  end


end
