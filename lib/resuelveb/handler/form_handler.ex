defmodule Resuelveb.FormHandler do

  def required(nil), do: false
  def required(""), do: false
  def required(_any), do: true

  def only_number(value), do: value |> String.match?(~r/^[0-9]*$/)


  def init_space(value),
    do:
      value
      |> String.split("")
      |> Enum.at(1) != " "

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

  def validate_all_form([{atom, value} | others], valid) do
    validate_all_form(others, value.valid? && valid)
  end

  def validate_all_form([], valid), do: valid

  def validate(rule = %{required: [func | others], valid?: valid}, message, value) do
    IO.inspect(func.func)
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

  def validate(rule = %{required: [], valid?: valid}, message, _value),
    do: %{valid?: valid, message: message}

end
