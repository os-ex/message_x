defmodule MessageXWeb.Components.ChatSuggestions do
  @moduledoc """
  ChatSuggestions component.
  """

  use MessageXWeb, :surface_component

  prop chat, :map, required: true
  prop messages, :list, required: true

  @doc """
  Render Component
  """
  def render(assigns) when is_map(assigns) do
    ~H"""
    <div class="level">
      <div class="level-left">
        <div class="level-item">
          <Button size="small" rounded color="info">Suggestion 1</Button>
        </div>
      </div>
    </div>
    """
  end
end
