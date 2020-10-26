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
end
