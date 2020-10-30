defmodule MessageXWeb.Components.ChatBubble do
  @moduledoc """
  ChatBubble component.
  """

  use MessageXWeb, :surface_component

  alias MessageX.NLP

  prop id, :string
  prop read, :boolean, default: false
  prop typing, :boolean, default: false
  prop delivered, :boolean, default: false
  prop message, :map, required: true

  def render_sample(assigns) do
    ~H"""
    <br />
    <div
    class={{
      imessage: true,
      "is-read": @read,
      "is-delivered": @delivered,
      "typing-indicator": @typing
    }}
    >
      <div
        class={{
          fromThem: @message.is_from_me in [0],
          myMessage: @message.is_from_me in [1]
        }}
      >
        <div>
          Sentiment: <b>{{ NLP.sentiment(@message.text) }}</b>
        </div>
        <pre>
          "{{ @message.text }}"
        </pre>
     </div>
    </div>
    <br />

    """
  end

  @doc """
  Render Component
  """
  def render(assigns) when is_map(assigns) do
    # {{ render_sample(assigns) }}
    ~H"""
    <div
      :if={{ not MessageHelpers.blank?(@message) or MessageHelpers.attachments?(@message) }}
      id="chat-bubble-{{ @id || @message.rowid }}"
      class={{
        imessage: true,
        "is-read": @read,
        "is-delivered": @delivered,
        "typing-indicator": @typing
      }}
    >
      <div
        class={{
          bubble: true,
          fromThem: @message.is_from_me in [0],
          myMessage: @message.is_from_me in [1]
        }}
      >
        <span :if={{ @typing }} />
        <span :if={{ @typing }} />
        <span :if={{ @typing }} />

        <Components.FileAttachment
          :if={{ not @typing }}
          :for={{ attachment <- @message.attachments }}
          attachment={{ attachment }}
        />
        <Components.RichText
          :if={{ not @typing }}
          text={{ @message.text }}
        />
        <date>
          <b>{{ MessageHelpers.sender_name(@message) }}</b>
          {{ MessageHelpers.format_datetime(@message.date_delivered) }}
        </date>
      </div>
    </div>
    """
  end
end
