defmodule MessageX.Chats.MessageAttachment do
  @moduledoc """
  Ash resource for message attachment joins.
  """

  use Ash.Resource, data_layer: AshPostgres.DataLayer

  alias MessageX.Chats.Attachment
  alias MessageX.Chats.Message

  postgres do
    table("message_attachment_join")
    repo(MessageX.Repo)
  end

  actions do
    read :read do
      primary?(true)
    end
  end

  @primary_key false
  attributes do
    attribute :message_id, :integer, primary_key?: true
    attribute :attachment_id, :integer, primary_key?: true
  end

  relationships do
    belongs_to :message, Message, destination_field: :rowid
    belongs_to :attachment, Attachment, destination_field: :rowid
  end
end
