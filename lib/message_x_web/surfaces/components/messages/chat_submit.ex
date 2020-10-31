defmodule MessageXWeb.Components.ChatSubmit do
  @moduledoc """
  ChatSubmit component.
  """

  use MessageXWeb, :surface_component

  prop chat, :map, required: true
  data message, :any

  @doc """
  Render Component
  """
  def render(assigns) when is_map(assigns) do
    ~H"""
    <div class="chat-submit-container">
      <article class="media">
        <div class="media-content">
          <Form for={{ :message }} submit="send-message" opts={{ autocomplete: "off" }}>
            <Field name="id" class="is-hidden">
              <Label>Chat ID</Label>
              <div class="control">
                <TextInput value={{ @chat.rowid }}/>
              </div>
            </Field>
            <Field name="text">
              <p class="control">
                <TextArea class="textarea" opts={{placeholder: "Message to Send..."}} rows="4" cols="4" />
              </p>
            </Field>
            <nav class="level">
              <div class="level-left">
              </div>
              <div class="level-right">
                <div class="level-item">
                  <Submit class="button is-primary">Send</Submit>
                </div>
              </div>
            </nav>
          </Form>
        </div>
      </article>
    </div>
    """
  end
end
