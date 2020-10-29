defmodule MessageXWeb.Scenes.Messages do
  @moduledoc """
  ChatBubble component.

  ## Examples
  ```
  <ChatBubble message={%Message{}}>
  ```
  """

  use MessageXWeb, :surface_live_component

  alias MessageXWeb.Components.ChatMessages
  alias MessageXWeb.Components.ChatSidebarItem

  prop loading, :boolean, default: false
  prop chats, :list, required: true, default: []
  prop current_chat, :map
  prop current_chat_messages, :list, default: []
  prop chats_meta, :map, required: true
  prop chat_messages_meta, :map, required: true

  def render_stats(assigns) do
    ~H"""
    <div class="hero is-info">
      <div class="hero-body">
        <nav class="level">
          <div class="level-item has-text-centered">
            <div>
              <p class="heading">Messages</p>
              <p class="title">{{ @current_chat_messages |> messages() |> length() }}</p>
            </div>
          </div>
          <div class="level-item has-text-centered">
            <div>
              <p class="heading">Attachments</p>
              <p class="title">{{ @current_chat_messages |> messages() |> attachments() |> length() }}</p>
            </div>
          </div>

          <div class="level-item has-text-centered">
            <div>
              <p class="heading">Attachments (no filename)</p>
              <p class="title">{{ @current_chat_messages |> messages() |> attachments() |> Enum.filter(& &1.filename == nil) |> length() }}</p>
            </div>
          </div>

          <div class="level-item has-text-centered">
            <div>
              <p class="heading">Attachments (hide_attachment)</p>
              <p class="title">{{ @current_chat_messages |> messages() |> attachments() |> Enum.filter(& &1.hide_attachment == 0) |> length() }}</p>
            </div>
          </div>

          <div class="level-item has-text-centered">
            <div>
              <p class="heading">Handles</p>
              <p class="title">{{ @current_chat |> handles() |> length() }}</p>
            </div>
          </div>
          <div class="level-item has-text-centered">
          <div>
            <p class="heading">Sentiment</p>
            <p class="title">{{ 0 }}</p>
          </div>
        </div>
          <div class="level-item has-text-centered">
            <div>
              <p class="heading">Chats</p>
              <p class="title">{{ length(@chats) }}</p>
            </div>
          </div>
        </nav>
      </div>
    </div>
    """
  end

  def render(assigns) do
    ~H"""
    <div class="columns">
      <div class="column is-3">
        <section id="chat-sidebar-section" class="section">
          <nav class="panel is-primary">
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
            <div class="chat-sidebar-scrollable">
              <LiveRedirect
                :for={{ chat <- @chats }}
                to={{Routes.chat_show_path(@socket, :show, chat)}}
                class="panel-block {{ active_class(@current_chat, chat) }}"
              >
                <ChatSidebarItem
                  id={{ chat.rowid }}
                  chat={{ chat }}
                />
              </LiveRedirect>
            </div>
          </nav>
        </section>
      </div>

      <div class="column">
        <section id="chat-messages-section" class="section">
          {{ render_stats(assigns) }}

          <ChatMessages
            :if={{ @current_chat }}
            loading={{ @loading }}
            id={{ identifier(@current_chat) }}
            chat={{ @current_chat }}
            messages={{ @current_chat_messages |> messages() }}
          />
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

  defp messages(chat_messages) when is_list(chat_messages) do
    Enum.map(chat_messages, & &1.message)
  end

  defp attachments(%{messages: messages}) when is_list(messages) do
    Enum.flat_map(messages, &attachments/1)
  end

  defp attachments(messages) when is_list(messages) do
    Enum.flat_map(messages, &attachments/1)
  end

  defp attachments(%{attachments: attachments}) when is_list(attachments), do: attachments
  defp attachments(_), do: []

  defp handles(%{handles: handles}) when is_list(handles), do: handles
  defp handles(_), do: []

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
