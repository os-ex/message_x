defmodule MessageXWeb.Components.ChatMessages do
  @moduledoc """
  ChatMessages component.
  """

  use MessageXWeb, :surface_component

  alias MessageX.ChatThreads

  prop chat, :map, required: true
  prop messages, :list, required: true

  def id(assigns) do
    assigns.messages
    |> Enum.map(& &1.rowid)
    |> Enum.concat([assigns.chat.rowid])
    |> Enum.join("-")
  end

  def id(assigns, _date, messages_by_handle) do
    messages_by_handle
    |> Enum.flat_map(fn {_handle, messages} ->
      messages
      |> Enum.map(& &1.rowid)
    end)
    |> Enum.concat([assigns.chat.rowid])
    |> Enum.join("-")
  end

  def render(%{assigns: %{chat: nil}}) do
    """
    No chat
    """
  end

  def render(%{assigns: %{chat: %{messages: []}}}) do
    """
    No Messages
    """
  end

  @doc """
  Render Component
  """
  def render(assigns) when is_map(assigns) do
    ~H"""
    <div
      id="chat-messages-container-{{ id(assigns) }}"
      class="chat-messages"
    >
      <form class="chat">
        <div
          :for={{ { date, messages_by_handle} <- ChatThreads.group_messages(@chat, @messages) }}
          id="chat-messages-date-thread-{{ id(assigns, date, messages_by_handle) }}"
        >

          <div class="imessage">
            <p class="chat-thread-timestamp">
              <Components.Timestamp datetime={{ date }} />
            </p>
          </div>

          <Components.ChatThread
            :for={{ { handle, messages} <- messages_by_handle }}
            handle={{ handle }}
            messages={{ messages }}
          />
        </div>
      </form>
    </div>
    """
  end
end
