defmodule MessageXWeb.Components.ScrollPaginateOffset do
  @moduledoc """
  ScrollPaginateOffset component.
  """

  use MessageXWeb, :surface_component
  import Ash.Notifier.LiveView

  prop event, :string, values: ["load-more"], default: "load-more"
  prop id, :string, required: true
  prop key, :string, default: "page"
  prop class, :css_class
  prop meta, :map, required: true

  slot default

  @doc """
  Render Component
  """
  def render(assigns) when is_map(assigns) do
    ~H"""
    <article class="scroll-paginate-content-wrapper">
      <div
        id={{ @id }}
        class={{
          "#{@class}": true,
          "scroll-paginate-overflow-container": true
        }}
        phx-update="append"
        phx-hook="InfiniteScroll"
        data-key={{ @key }}
        data-page={{ page_number(@meta) }}
      >
        <slot />
      </div>
    </article>
    """
  end
end
