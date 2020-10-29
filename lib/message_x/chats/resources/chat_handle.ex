defmodule MessageX.Chats.ChatHandle do
  @moduledoc """
  Ash resource for chat handle joins.
  """

  use Ash.Resource, data_layer: AshPostgres.DataLayer

  alias MessageX.Chats.Chat
  alias MessageX.Chats.Handle

  postgres do
    table("chat_handle_join")
    repo(MessageX.Repo)
  end

  actions do
    read :read do
      primary?(true)
    end
  end

  @primary_key false
  attributes do
    attribute :chat_id, :integer, primary_key?: true
    attribute :handle_id, :integer, primary_key?: true
  end

  relationships do
    belongs_to :chat, Chat, destination_field: :rowid
    belongs_to :handle, Handle, destination_field: :rowid
  end
end
