defmodule MessageXWeb.Components.ChatThread do
  @moduledoc """
  ChatThread component.
  """

  use MessageXWeb, :surface_component

  prop handle, :map, required: true
  prop messages, :list, required: true, default: []

  @doc """
  Render Component
  """
  def render(assigns) when is_map(assigns) do
    ~H"""
    <Components.ChatBubble
      :for={{ message <- @messages }}
      typing={{ MessageHelpers.typing?(message) }}
      message={{ message }}
    />
    """
  end
end
