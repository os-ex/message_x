defmodule MessageX.Types do
  @moduledoc """
  Data Types
  """

  def constraints(:boolean_int) do
    [min: 0, max: 1]
  end

  def constraints(:unix_timestamp) do
    [min: 0]
  end
end
