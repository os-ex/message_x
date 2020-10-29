defmodule MessageXWeb.Components.Statistic do
  @moduledoc """
  Statistic component.
  """

  use MessageXWeb, :surface_component

  prop title, :string, required: true
  prop subtitle, :string
  prop value, :string, required: true

  def title(title, nil) do
    "#{title}"
  end

  def title(title, subtitle) do
    "#{title} (#{subtitle})"
  end

  def render(assigns) do
    ~H"""
    <div class="level-item has-text-centered">
      <div>
        <p class="heading">{{ title(@title, @subtitle) }}</p>
        <p class="title">{{ @value }}</p>
      </div>
    </div>
    """
  end
end
