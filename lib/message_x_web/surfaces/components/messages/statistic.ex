defmodule MessageXWeb.Components.Statistic do
  @moduledoc """
  Statistic component.
  """

  use MessageXWeb, :surface_component

  prop title, :string, required: true
  prop subtitle, :string
  prop value, :any, required: true

  @doc """
  Subtitle text.
  """
  @spec subtitle_text(any()) :: String.t()
  def subtitle_text(nil), do: ""
  def subtitle_text(subtitle), do: " (#{subtitle})"

  @doc """
  Render Component
  """
  def render(assigns) when is_map(assigns) do
    ~H"""
    <div class="level-item has-text-centered">
      <div>
        <p class="heading">
          {{ @title }}
          {{ subtitle_text(@subtitle) }}
        </p>
        <p class="title">{{ @value }}</p>
      </div>
    </div>
    """
  end
end
