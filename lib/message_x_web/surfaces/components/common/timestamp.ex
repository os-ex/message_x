defmodule MessageXWeb.Components.Timestamp do
  @moduledoc """
  Timestamp component.

  ## Examples
  ```
  <Timestamp datetime={{ %DateTime{} }} />
  ```
  """

  use MessageXWeb, :surface_component

  prop datetime, :datetime, required: true

  @doc """
  Render Component
  """
  def render(assigns) when is_map(assigns) do
    ~H"""
    <time
      datetime="{{ MessageHelpers.format_datetime(@datetime) }}"
    >
      {{ MessageHelpers.relative_datetime_format(@datetime) }}
    </time>
    """
  end
end
