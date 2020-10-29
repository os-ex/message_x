defmodule MessageX.Chats.Api do
  use Ash.Api,
    extensions: [
      AshJsonApi.Api,
      AshGraphql.Api
    ]

  alias MessageX.Chats.Attachment
  alias MessageX.Chats.Chat
  alias MessageX.Chats.ChatHandle
  alias MessageX.Chats.ChatMessage
  alias MessageX.Chats.Handle
  alias MessageX.Chats.Message
  alias MessageX.Chats.MessageAttachment

  # graphql do
  #   authorize?(true)
  # end

  resources do
    resource(Attachment)
    resource(Chat)
    resource(ChatHandle)
    resource(ChatMessage)
    resource(Handle)
    resource(Message)
    resource(MessageAttachment)
  end

  def list_chats(actor, params \\ %{}, page_opts \\ nil) when is_map(params) do
    Chat
    |> Ash.Query.sort(rowid: :desc)
    |> Ash.Query.load([
      :handles,
      messages: [
        :handle,
        :attachments
      ]
      # :messages
      # messages: :attachments
    ])
    # |> Ash.Query.limit(1)
    # |> Ash.Query.limit(3)
    |> read!(
      action: :index,
      actor: actor
      # page: [limit: 1, offset: 0]
      # page: [limit: 1]
      # page: [count: true, limit: 1, offset: 50]
      # page: page_opts || page_from_params(params["page"], 5, true)
      # page: page_opts
    )
  end

  def get_chat(%{"chat_id" => chat_id}) do
    Chat
    |> Ash.Query.sort(rowid: :desc)
    |> Ash.Query.load([
      :handles,
      messages: [
        :handle,
        :attachments
      ]
      # :messages
      # messages: :attachments
    ])
    # |> Ash.Query.limit(1)
    # |> Ash.Query.limit(3)
    |> read!(
      action: :read
      # actor: socket.assigns.actor,
      # page: [limit: 1, offset: 0]
      # page: [limit: 1]
      # page: [count: true, limit: 1, offset: 50]
      # page: page_opts || page_from_params(params["page"], 5, true)
      # page: page_opts
    )
  end
end
