defmodule MessageXWeb.Components.ChatSidebarSearch do
  @moduledoc """
  ChatSidebarSearch component.
  """

  use MessageXWeb, :surface_component

  prop results, :list, default: []

  @doc """
  Render Component
  """
  def render(assigns) when is_map(assigns) do
    ~H"""
    <p class="panel-heading"> Friends </p>
    <div class="panel-block">
      <p class="control has-icons-left">
        <input class="input" type="text" placeholder="Search">
        <span class="icon is-left">
          <i class="fa fa-search"></i>
        </span>
      </p>
    </div>
    <p class="panel-tabs">
      <a class="is-active">All</a>
      <a>Friends</a>
      <a>Unknown Sender</a>
    </p>
    """
  end
end
