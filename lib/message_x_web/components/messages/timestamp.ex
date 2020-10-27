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

  def render(assigns) do
    ~H"""
    <time datetime="{{ format_datetime(@datetime) }}">
      {{ relative_datetime_format(@datetime) }}
    </time>
    """
  end
end
