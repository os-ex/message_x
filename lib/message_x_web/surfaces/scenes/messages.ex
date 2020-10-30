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

  prop chats, :list, required: true, default: []
  prop current_chat, :map
  prop messages, :list, default: []
  prop chats_meta, :map, required: true
  prop messages_meta, :map, required: true

  @doc """
  Render Component
  """
  def render(assigns) when is_map(assigns) do
    ~H"""
    <div class="columns">
      <div class="column is-3">
        <section id="chat-sidebar-section" class="section">
          <nav class="panel is-primary">
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
                  "is-active": active_chat?(@current_chat, chat)
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
          </nav>
        </section>
      </div>

      <div class="column">
        <section id="chat-messages-section" class="section">
          <ChatHero
            chats={{ @chats }}
            current_chat={{ @current_chat }}
            messages={{ @messages }}
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
              :if={{ @current_chat }}
              chat={{ @current_chat }}
              messages={{ @messages  }}
            />
          </ScrollPaginateOffset>

          <ChatSubmit />
        </section>
      </div>
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
