defmodule MessageXWeb.Components.ChatThread do
  @moduledoc """
  ChatThread component.

  ## Examples
  ```
  <ChatThread form="user" field="birthday" opts={{ autofocus: "autofocus" }}>
  ```
  """

  use MessageXWeb, :surface_component

  prop handle, :map
  prop messages, :list, required: true, default: []

  def render(assigns) do
    ~H"""
    <div>
      <Components.ChatBubble
        :for={{ message <- @messages }}
        message={{ message }}
      />
    </div>
    """
  end
end
