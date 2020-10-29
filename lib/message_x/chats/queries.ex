defmodule MessageX.Chats.Queries do
  @moduledoc """
  Queries for `MessageX.Chats.API`
  """

  alias MessageX.Chats.Chat
  alias MessageX.Chats.Handle
  alias MessageX.Chats.Message

  def list_chats do
    Chat
    |> Ash.Query.sort(rowid: :desc)
  end

  def list_messages do
    Message
    |> Ash.Query.sort(rowid: :desc)
  end

  def list_handles do
    Handle
    |> Ash.Query.sort(rowid: :desc)
  end

  def list_chats_with_messages do
    list_chats()
    |> load_chat_messages()
  end

  def load_chat_messages(query) do
    query
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
  end
end
