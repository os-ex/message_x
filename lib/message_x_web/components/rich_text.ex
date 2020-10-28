defmodule MessageXWeb.Components.RichText do
  @moduledoc """
  RichText component.

  ## Examples
  ```
  <RichText form="user" field="birthday" opts={{ autofocus: "autofocus" }}>
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
