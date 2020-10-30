defmodule MessageXWeb.Components.ChatBubble do
  @moduledoc """
  ChatBubble component.
  """

  use MessageXWeb, :surface_component

  alias MessageX.NLP

  prop message, :map, required: true
  prop typing, :boolean, default: false

  def render_sample(assigns) do
    ~H"""
    <br />
    <div class="imessage">
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

  def render(assigns) do
    ~H"""
    {{ render_sample(assigns) }}
    <div
      id="chat-bubble-{{ @message.rowid }}"
      class={{
        imessage: true,
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
