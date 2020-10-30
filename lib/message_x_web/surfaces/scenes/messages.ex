defmodule MessageXWeb.Scenes.Messages do
  @moduledoc """
  Messages component.
  """

  use MessageXWeb, :surface_live_component

  # Sidebar
  alias MessageXWeb.Components.ChatSidebarItem
  alias MessageXWeb.Components.ChatSidebarSearch

  # Messages
  alias MessageXWeb.Components.ChatHero
  alias MessageXWeb.Components.ChatMessages
  alias MessageXWeb.Components.ChatSubmit

  # Pagination
  alias MessageXWeb.Components.ScrollPaginateOffset

  prop chat, :map
  prop chats, :list, default: [], required: true
  prop messages, :list, default: [], required: true
  prop filtered_messages, :list, default: []
  prop chats_meta, :map, required: true
  prop messages_meta, :map

  @doc """
  Render Component
  """
  def render(assigns) when is_map(assigns) do
    ~H"""
    <div class="columns is-gapless messages-container">
      <article class="column is-4 chat-sidebar-container">
        <div class="hero is-fullheight">
          <ChatSidebarSearch />
          <ScrollPaginateOffset
            id="chats-sidebar-scroll-pagination"
            class="chat-sidebar-scrollable"
            key="chat_page"
            meta={{ @chats_meta }}
          >
            <LiveRedirect
              :for={{ chat <- @chats }}
              class={{
                "panel-block": true,
                "is-active": active_chat?(@chat, chat)
              }}
              to={{Routes.chat_show_path(@socket, :show, chat)}}
              opts={{ id: "chat-sidebar-redirect-#{chat.rowid}" }}
            >
              <ChatSidebarItem
                id="chat-sidebar-item-{{ chat.rowid }}"
                chat={{ chat }}
              />
            </LiveRedirect>
          </ScrollPaginateOffset>
        </div>
      </article>
      <article class="column is-8">
        <div class="hero is-fullheight">
          <ChatHero
            chat={{ @chat }}
            chats={{ @chats }}
            messages={{ @messages }}
            filtered_messages={{ @filtered_messages }}
            chats_meta={{ @chats_meta }}
            messages_meta={{ @messages_meta }}
          />
          <ScrollPaginateOffset
            id="messages-scroll-pagination"
            class="chat-messages-scrollable"
            key="messages_page"
            meta={{ @messages_meta }}
          >
            <ChatMessages
              :if={{ @chat }}
              chat={{ @chat }}
              messages={{ @messages  }}
            />
          </ScrollPaginateOffset>
          <ChatSubmit />
        </div>
      </article>
    </div>
    """
  end

  def active_chat?(%{rowid: current_rowid}, %{rowid: index_rowid})
      when is_integer(current_rowid) and current_rowid == index_rowid do
    true
  end

  def active_chat?(_, _) do
    false
  end
end
