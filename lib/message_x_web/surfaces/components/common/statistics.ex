defmodule MessageXWeb.Components.Statistics do
  @moduledoc """
  Statistics component.
  """

  use MessageXWeb, :surface_component

  alias MessageXWeb.Components.Statistic

  @sizes ["small", "medium", "large"]
  @colors ["primary", "info", "success", "warning"]

  prop title, :string, required: true
  prop items, :list, required: true, default: []
  prop size, :string, values: @sizes, default: "medium"
  prop color, :string, values: @colors, default: "primary"

  @doc """
  Render Component
  """
  def render(assigns) when is_map(assigns) do
    ~H"""
    <div class="hero is-{{ @size }} is-{{ @color }}">
      <div class="hero-body">
        <div class="container">
          <h1 class="title">
            {{ @title }}
          </h1>
          <nav class="level">
            <Statistic
              :for={{ item <- @items }}
              title={{ item.title }}
              value={{ item.value }}
            />
          </nav>
        </div>
      </div>
    </div>
    """
  end
end
