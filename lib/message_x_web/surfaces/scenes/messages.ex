defmodule MessageXWeb.Scenes.Messages do
  @moduledoc """
  ChatBubble component.

  ## Examples
  ```
  <ChatBubble message={%Message{}}>
  ```
  """

  use MessageXWeb, :surface_live_component
  # import Ash.Notifier.LiveView

  alias MessageXWeb.Components.ChatHero
  alias MessageXWeb.Components.ChatMessages
  alias MessageXWeb.Components.ChatSidebarItem
  alias MessageXWeb.Components.ChatSidebarSearch

  alias MessageXWeb.Components.ScrollPaginateOffset

  prop loading, :boolean, default: false
  prop chats, :list, required: true, default: []
  prop current_chat, :map
  prop current_messages, :list, default: []
  prop chats_meta, :map, required: true
  prop messages_meta, :map, required: true

  def render(assigns) do
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
                  "is-active": active?(@current_chat, chat)
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
            loading={{ @loading }}
            chats={{ @chats }}
            current_chat={{ @current_chat }}
            current_messages={{ @current_messages }}
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
              loading={{ @loading }}
              chat={{ @current_chat }}
              messages={{ @current_messages  }}
            />
          </ScrollPaginateOffset>
        </section>
      </div>
    </div>
    """
  end

  @doc """


  Count
  <pre>
  {{ inspect(@chat_messages_meta, pretty: true) }}
  </pre>

  <pre>
  {{ inspect(@current_chat, pretty: true) }}
  </pre>
  """
  defp identifier(%{rowid: rowid}), do: rowid
  defp identifier(_), do: nil

  def active_class(current_chat, chat) do
    if active?(current_chat, chat) do
      "is-active"
    else
      ""
    end
  end

  def active?(%{rowid: current_rowid}, %{rowid: index_rowid})
      when is_integer(current_rowid) and current_rowid == index_rowid do
    true
  end

  def active?(_, _) do
    false
  end
end
