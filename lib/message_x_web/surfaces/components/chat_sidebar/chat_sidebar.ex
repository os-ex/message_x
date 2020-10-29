defmodule MessageXWeb.Components.ChatSidebar do
  @moduledoc """
  ChatSidebar component.

  ## Examples
  ```
  <ChatSidebar form="user" field="birthday" opts={{ autofocus: "autofocus" }}>
  ```
  """

  use MessageXWeb, :surface_component

  prop chats, :list, required: true, default: []

  def render(assigns) do
    # <div id="window-controls">
    #   <button id="close">x</button>
    #   <button id="minimize">–</button>
    #   <button id="maximize">+</button>
    # </div>
    # <div id="controls">
    #   <i class="fas fa-search"></i>
    #   <input placeholder="Search" />
    #   <button class="new-message"></button>
    # </div>
    ~H"""
    <aside id="chat-sidebar" class="menu section">
      <p class="menu-label"> Chats </p>
      <ul class="menu-list">
        <Components.ChatSidebarItem
          :for={{ chat <- @chats }}
          id={{ chat.rowid }}
          chat={{ chat }}
        />
      </ul>
    </aside>
    """
  end
end
