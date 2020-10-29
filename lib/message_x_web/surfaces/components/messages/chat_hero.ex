defmodule MessageXWeb.Components.ChatHero do
  @moduledoc """
  ChatHero component.

  ## Examples
  ```
  <ChatHero form="user" field="birthday" opts={{ autofocus: "autofocus" }}>
  ```
  """

  use MessageXWeb, :surface_component
  # import Ash.Notifier.LiveView

  prop loading, :boolean, default: false
  prop chats, :list, required: true, default: []
  prop current_chat, :map
  prop current_messages, :list, default: []
  prop chats_meta, :map, required: true
  prop messages_meta, :map, required: true

  def render(assigns) do
    ~H"""
    <div class="hero is-info">
      <div class="hero-body">
        <nav class="level">
          <div class="level-item has-text-centered">
            <div>
              <p class="heading">Messages</p>
              <p class="title">{{ @current_messages  |> length() }}</p>
            </div>
          </div>
          <div class="level-item has-text-centered">
            <div>
              <p class="heading">Messages</p>
              <p class="title">{{ @messages_meta.limit + @messages_meta.offset }}</p>
            </div>
          </div>
          <div class="level-item has-text-centered">
            <div>
              <p class="heading">Messages (Total)</p>
              <p class="title">{{ @messages_meta.count }}</p>
            </div>
          </div>
          <div class="level-item has-text-centered">
            <div>
              <p class="heading">Attachments</p>
              <p class="title">{{ @current_messages  |> attachments() |> length() }}</p>
            </div>
          </div>

          <div class="level-item has-text-centered">
            <div>
              <p class="heading">Attachments (no filename)</p>
              <p class="title">{{ @current_messages  |> attachments() |> Enum.filter(& &1.filename == nil) |> length() }}</p>
            </div>
          </div>

          <div class="level-item has-text-centered">
            <div>
              <p class="heading">Attachments (hide_attachment)</p>
              <p class="title">{{ @current_messages  |> attachments() |> Enum.filter(& &1.hide_attachment == 0) |> length() }}</p>
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
          <div class="level-item has-text-centered">
            <div>
              <p class="heading">Chats (total) </p>
              <p class="title">{{ @chats_meta.count }}</p>
            </div>
          </div>
        </nav>
      </div>
    </div>
    """
  end

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
end
