defmodule MessageXWeb.Components.ChatBubble do
  @moduledoc """
  ChatBubble component.

  ## Examples
  ```
  <ChatBubble message={%Message{}}>
  ```
  """

  use MessageXWeb, :surface_component
  import MessageXWeb.MessageHelpers

  prop message, :map, required: true

  defp sender_class(%{is_from_me: 0}), do: "fromThem"
  defp sender_class(%{is_from_me: 1}), do: "myMessage"

  def render(assigns) do
    ~H"""
    <div
      id="chat-bubble-{{ @message.rowid }}"
      class="imessage"
    >
      <div class="{{ sender_class(@message) }}">
        <Components.FileAttachment
          :for={{ attachment <- @message.attachments }}
          attachment={{ attachment }}
        />
        <Components.RichText text={{ @message.text }} />
        <date>
          <b>{{ sender_name(@message) }}</b>
          {{ format_datetime(@message.date_delivered) }}
        </date>
      </div>
    </div>
    """
  end
end
