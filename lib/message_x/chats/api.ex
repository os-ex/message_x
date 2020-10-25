defmodule MessageX.Chats.Api do
  use Ash.Api,
    extensions: [
      AshJsonApi.Api,
      AshGraphql.Api
    ]

  alias MessageX.Chats.{Attachment, Message, Chat}

  graphql do
    authorize?(true)
  end

  resources do
    resource(Attachment)
    resource(Message)
    resource(Chat)
  end
end
