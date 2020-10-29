defmodule MessageX.Chats.ChatMessage do
  @moduledoc """
  Ash resource for chat message joins.
  """

  use Ash.Resource, data_layer: AshPostgres.DataLayer

  alias MessageX.Types

  alias MessageX.Chats.Chat
  alias MessageX.Chats.Message

  postgres do
    table("chat_message_join")
    repo(MessageX.Repo)
  end

  actions do
    read :read do
      primary?(true)
    end

    read :in_chat do
      # sort(message_date: :asc)
      # filter:
      pagination(
        # countable: :by_default,
        # default_limit: 250,
        # max_page_size: 250,
        offset?: true,
        keyset?: true,
        # required?: true
        required?: true
      )
    end
  end

  @primary_key false
  attributes do
    attribute :chat_id, :integer, primary_key?: true
    attribute :message_id, :integer, primary_key?: true

    attribute :message_date, :integer do
      description """
      Datetime when the message was created.
      """

      constraints Types.constraints(:unix_timestamp)
    end
  end

  relationships do
    belongs_to :chat, Chat, destination_field: :rowid
    belongs_to :message, Message, destination_field: :rowid
  end
end
