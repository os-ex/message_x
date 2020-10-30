defmodule MessageXWeb.Components.RichText do
  @moduledoc """
  RichText component.

  ## Examples
  ```
  <RichText text="sample text" />
  ```
  """

  use MessageXWeb, :surface_component

  prop text, :string, required: true

  @doc """
  Render Component
  """
  def render(assigns) when is_map(assigns) do
    ~H"""
    <p>
      {{ MessageHelpers.rich_text(@text, replace: [:emoji, :url]) }}
    </p>
    """
  end
end
