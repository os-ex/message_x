defmodule MessageXWeb.Components.PaginateItem do
  @moduledoc """
  PaginateItem component.
  """

  use MessageXWeb, :surface_component

  @doc "Control if item is disabled"
  prop disabled, :boolean, default: false

  prop href, :string, default: "#"
  prop key, :string, required: true
  prop value, :string, required: true
  prop click, :event, required: true
  prop label, :string, required: true

  def render(assigns) do
    #
    ~H"""
    <li class="pagination-item">
      <a
        class={{
          "px-2": true,
          "py-2": true,
          "text-gray-600": @disabled,
          "pointer-events-none": @disabled
        }}
        href={{ @href }}
        value={{ @value }}
        :on-click={{ @click }}
        :attrs={{ %{"phx-value-#{@key}": @value} }}
      >
        {{ @label }}
      </a>
    </li>
    """
  end
end
