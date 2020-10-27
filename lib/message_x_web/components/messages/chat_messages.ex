defmodule MessageXWeb.Components.ChatMessages do
  @moduledoc """
  ChatMessages component.

  ## Examples
  ```
  <ChatMessages form="user" field="birthday" opts={{ autofocus: "autofocus" }}>
  ```
  """

  use MessageXWeb, :surface_component

  alias MessageX.ChatThreads

  prop chat, :map, required: true

  # def render_header(assigns) do
  #   ~H"""
  #   <nav class="level">
  #     <div class="level-item has-text-centered">
  #       <div>
  #         <p class="heading">Messages</p>
  #         <p class="title">{{ length(@chat.messages) }}</p>
  #       </div>
  #     </div>
  #     <div class="level-item has-text-centered">
  #       <div>
  #         <p class="heading">Attachments</p>
  #         <p class="title">{{ length(@chat.messages) }}</p>
  #       </div>
  #     </div>
  #     <div class="level-item has-text-centered">
  #       <div>
  #         <p class="heading">Sentiment</p>
  #         <p class="title">{{ length(@chat.messages) }}</p>
  #       </div>
  #     </div>
  #     <div class="level-item has-text-centered">
  #       <div>
  #         <p class="heading">Likes</p>
  #         <p class="title">{{ length(@chat.messages) }}</p>
  #       </div>
  #     </div>
  #   </nav>
  #   """
  # end

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

  def render(assigns) do
    # {{ render_header(assigns) }}
    ~H"""
    <div id="chat-messages-{{ @chat.rowid }}">
      <div :for={{ { date, messages_by_handle} <- ChatThreads.group_messages(@chat) }}>
        <Components.Timestamp datetime={{ date }} />
        <Components.ChatThread
          :for={{ { handle, messages} <- messages_by_handle }}
          handle={{ handle }}
          messages={{ messages }}
        />
      </div>

      {{ render_footer(assigns) }}
    </div>
    """
  end

  defp render_footer(assigns) do
    ~H"""
      <article class="media">
        <figure class="media-left">
          <p class="image is-64x64">
            <img src="https://s3.amazonaws.com/uifaces/faces/twitter/zeldman/128.jpg">
          </p>
        </figure>
        <div class="media-content">
          <div class="field">
            <p class="control">
              <textarea class="textarea" placeholder="Add a comment..."></textarea>
              <TextArea opts={{placeholder: "Message to Send..."}} rows="4" cols="4" />
            </p>
          </div>
          <nav class="level">
            <div class="level-left">
              <div class="level-item">
                <a class="button is-info">Send</a>
              </div>
            </div>
            <div class="level-right">
              <div class="level-item">
                <label class="checkbox">
                  <input type="checkbox"> Press enter to submit
                </label>
                <Submit size="large" color="primary">Send</Submit>
              </div>
            </div>
          </nav>
        </div>
      </article>
    """
  end
end
