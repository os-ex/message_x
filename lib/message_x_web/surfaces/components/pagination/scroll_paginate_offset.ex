defmodule MessageXWeb.Components.ScrollPaginateOffset do
  @moduledoc """
  ScrollPaginateOffset component.
  """

  use MessageXWeb, :surface_component
  import Ash.Notifier.LiveView

  prop id, :string, required: true
  prop key, :string, default: "page"
  prop class, :string
  prop meta, :map, required: true

  slot default

  def render(assigns) do
    ~H"""
    <div
      id={{ @id }}
      class={{
        "scroll-paginated-offset": true,
        "#{@class}": true
      }}
      phx-update="append"
      phx-hook="InfiniteScroll"
      data-key={{ @key }}
      data-page={{ page_number(@meta) }}
    >
      <slot />
    </div>
    """
  end
end
