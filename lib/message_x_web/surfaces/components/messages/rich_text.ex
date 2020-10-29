defmodule MessageXWeb.Components.RichText do
  @moduledoc """
  RichText component.

  ## Examples
  ```
  <RichText text="sample text" />
  ```
  """

  use MessageXWeb, :surface_component
  import MessageXWeb.MessageHelpers

  prop text, :string, required: true

  def render(assigns) do
    ~H"""
    <p>
      {{ rich_text(@text, replace: [:emoji, :url]) }}
    </p>
    """
  end
end
