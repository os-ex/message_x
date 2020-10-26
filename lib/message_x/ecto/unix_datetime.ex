defmodule MessageX.Ecto.UnixDatetime do
  @moduledoc """
  Representation for a datetime stored as a unix epoch integer
  """

  @behaviour Ecto.Type

  @time_unit :microsecond
  @datatype :utc_datetime_usec

  @doc """
  Ecto storage type
  """
  @spec type() :: :utc_datetime_usec
  def type, do: @datatype

  def cast(%DateTime{} = datetime) do
    DateTime.to_unix(datetime, @time_unit)
  end

  def cast(%NaiveDateTime{} = naive_datetime) do
    naive_datetime
    |> DateTime.from_naive("Etc/UTC")
    |> cast()
  end

  def cast(integer) when is_integer(integer) do
    integer
    |> DateTime.from_unix(@time_unit)
    |> cast()
  end

  def cast(binary) when is_binary(binary) do
    case DateTime.from_iso8601(binary) do
      {:ok, datetime} ->
        cast(datetime)

      _ ->
        case String.to_integer(binary) do
          {integer, ""} -> cast(integer)
          _ -> :error
        end
    end
  end

  def cast(_), do: :error

  def dump(value) do
    Ecto.Type.dump(@datatype, value)
  end

  def load(value) do
    Ecto.Type.load(@datatype, value)
  end

  def embed_as(date) do
    date
  end

  def equal?(left, right) do
    cast(left) == cast(right)
  end

  def parse(date) do
    date
    |> DateTime.to_naive()
    |> DateTime.from_naive("Etc/UTC")
  end
end
