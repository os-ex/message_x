defmodule MessageXWeb.Components.ChatThread do
  @moduledoc """
  ChatThread component.
  """

  use MessageXWeb, :surface_component

  prop handle, :map
  prop messages, :list, required: true, default: []

  def render(assigns) do
    ~H"""
    <Components.ChatBubble
      :for={{ message <- @messages }}
      message={{ message }}
    />
    """
  end
end
