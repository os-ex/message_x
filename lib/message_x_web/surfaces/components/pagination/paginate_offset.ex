defmodule MessageXWeb.Components.PaginateOffset do
  @moduledoc """
  PaginateOffset component.
  """

  use MessageXWeb, :surface_component
  import Ash.Notifier.LiveView

  alias MessageXWeb.Components.PaginateItem

  prop event, :string, default: "nav"
  prop key, :string, default: "page"
  prop meta, :map, required: true

  @doc """
  Render Component
  """
  def render(assigns) when is_map(assigns) do
    ~H"""
    <nav class="border-t border-gray-200">
      <ul class="flex my-2">
        <PaginateItem
          :if={{ can_link_to_page?(@meta, "prev") }}
          disabled={{ not can_link_to_page?(@meta, "prev") }}
          key={{ @key }}
          click={{ @event }}
          label="Previous"
          value={{ :prev }}
        />
        <PaginateItem
          :if={{ last_page(@meta) != :unknown }}
          :for={{ idx <- 1..last_page(@meta) }}
          disabled={{ on_page?(@meta, idx) }}
          key={{ @key }}
          click={{ @event }}
          label={{ idx }}
          value={{ idx }}
        />
        <PaginateItem
          :if={{ can_link_to_page?(@meta, "next") }}
          disabled={{ not can_link_to_page?(@meta, "next") }}
          key={{ @key }}
          click={{ @event }}
          label="Next"
          value={{ :next }}
        />
      </ul>
    </nav>
    """
  end
end
