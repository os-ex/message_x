defmodule MessageX.Chats.Api do
  use Ash.Api,
    extensions: [
      AshJsonApi.Api,
      AshGraphql.Api
    ]

  require Ash.Query

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

  def list_messages_paginated(socket, page_opts, params) do
    MessageX.Chats.Message
    |> Ash.Query.filter(chat_message: [chat_id: params["id"]])
    |> Ash.Query.sort(date: :asc)
    |> Ash.Query.load([
      :chat_message,
      :handle,
      :handle_of_other,
      :attachments
    ])
    |> MessageX.Chats.Api.read!(
      action: :in_chat,
      # filter: [rowid: params["id"]],
      # actor: socket.assigns.actor,
      # page: [count: true, limit: 1, offset: 50]
      page: page_opts || Ash.Notifier.LiveView.page_from_params(params["messages_page"], 5, true)
      # page: page_opts
    )
  end

  def list_chats_paginated(socket, page_opts, params) do
    MessageX.Chats.Chat
    |> Ash.Query.filter(rowid < 1000)
    |> Ash.Query.sort(rowid: :desc)
    |> Ash.Query.load([
      :handle_last_addressed,
      :handles
      # :messages
      # messages: [
      #   # :handle,
      #   # :handle_of_other,
      #   # :attachments
      # ]
      # :messages
      # messages: :attachments
    ])
    # |> Ash.Query.limit(1)
    # |> Ash.Query.limit(3)
    |> MessageX.Chats.Api.read!(
      action: :most_recent,
      # actor: socket.assigns.actor,
      # page: [limit: 1, offset: 0]
      # page: [limit: 1]
      # page: [count: true, limit: 1, offset: 50]
      page: page_opts || Ash.Notifier.LiveView.page_from_params(params["chat_page"], 5, true)
      # page: page_opts
    )
  end

  def list_chat_messages_paginated(socket, page_opts, params) do
    MessageX.Chats.ChatMessage
    |> Ash.Query.filter(chat_id: params["id"])
    |> Ash.Query.sort(message_date: :asc)
    |> Ash.Query.load(
      message: [
        :handle,
        :handle_of_other,
        :attachments
      ]
    )
    |> MessageX.Chats.Api.read!(
      action: :in_chat,
      # filter: [rowid: params["id"]],
      # actor: socket.assigns.actor,
      # page: [count: true, limit: 1, offset: 50]
      page: page_opts || Ash.Notifier.LiveView.page_from_params(params["page"], 5, true)
      # page: page_opts
    )
  end

  def get_current_chat(socket, page_opts, params) do
    result =
      MessageX.Chats.Chat
      # |> Ash.Query.load([
      #   :handle_last_addressed,
      #   :handles,
      #   messages: [
      #     :handle,
      #     :handle_of_other,
      #     :attachments
      #   ]
      #   # :messages
      #   # messages: :attachments
      # ])
      # |> Ash.Query.limit(1)
      # |> Ash.Query.limit(3)
      |> MessageX.Chats.Api.get!(
        params["id"],
        load: [
          :handle_last_addressed,
          :handles
          # :messages
          # messages: [
          #   :handle,
          #   # :handle_of_other,
          #   :attachments
          # ]
          # :messages
          # messages: :attachments
        ]
        # params
        # action: :most_recent,
        # actor: socket.assigns.actor,
        # page: [limit: 1, offset: 0]
        # page: [limit: 1]
        # page: [count: true, limit: 1, offset: 50]
        # page: page_opts
      )

    # IO.inspect(result, pretty: true)

    result
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
