defmodule Resuelveb.FormHandler do
  @moduledoc """
    This module generically and specifically validates the values of the forms
  """

  @spec required(any) :: boolean
  def required(nil), do: false
  def required(""), do: false
  def required(_any), do: true

  @spec only_number(binary) :: boolean
  def only_number(value), do: value |> String.match?(~r/^[0-9]*$/)

  @spec json(
          binary
          | maybe_improper_list(
              binary | maybe_improper_list(any, binary | []) | byte,
              binary | []
            )
        ) :: true
  def json(value) do
    value
    |> Poison.decode
    |> case do
      {:ok, _val} -> true
      _ -> false
    end
  end

  @spec init_space(binary) :: boolean
  def init_space(value),
    do:
      value
      |> String.split("")
      |> Enum.at(1) != " "

  @spec validate_form(map, binary, any) :: map
  def validate_form(rules, target, value) do
    rule =
      rules
      |> Map.get(target |> String.to_atom())
      |> Map.put(:valid?, true)

    result =
      rule
      |> validate("", value)

    rules =
      rules
      |> Map.put(
        target |> String.to_atom(),
        rule
        |> Map.put(:valid?, result.valid?)
        |> Map.put(:message, result.message)
      )

    rules
  end

  @spec validate_all_form([{any, atom | map}], any) :: any
  def validate_all_form([{_atom, value} | others], valid) do
    validate_all_form(others, value.valid? && valid)
  end

  def validate_all_form([], valid), do: valid

  @spec validate(%{:required => [atom | map], :valid? => any, optional(any) => any}, any, any) ::
          %{message: any, valid?: any}
  def validate(rule = %{required: [func | others], valid?: valid}, message, value) do
    new_valid = func.func.(value)

    rule =
      rule
      |> Map.put(:required, others)
      |> Map.put(:valid?, new_valid && valid)

    message =
      case new_valid do
        true -> message
        false -> func.message
      end

    validate(rule, message, value)
  end

  def validate(%{required: [], valid?: valid}, message, _value),
    do: %{valid?: valid, message: message}

end
