defmodule MessageX.Chats.Chat do
  @moduledoc """
    Ash resource for chats.
  """

  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    notifiers: [Ash.Notifier.PubSub]

  alias MessageX.Types

  alias MessageX.Chats.ChatHandle
  alias MessageX.Chats.ChatMessage
  alias MessageX.Chats.Handle
  alias MessageX.Chats.Message

  pub_sub do
    # A prefix for all messages
    prefix("chat")
    # The module to call `broadcast/3` on
    module(MessageXWeb.Endpoint)

    # # When a chat is assigned, publish chat:assigned_to:<message_id>
    # publish(:assign, ["assigned_to", :message_id])
    # publish_all(:update, ["updated", :message_id])
    # publish_all(:update, ["updated", :reporter_id])
  end

  actions do
    read :read do
      primary?(true)
    end

    read :most_recent do
      pagination(
        countable: :by_default,
        default_limit: 5,
        max_page_size: 20,
        offset?: true,
        keyset?: true,
        required?: true
      )
    end
  end

  postgres do
    table("chat")
    repo(MessageX.Repo)
  end

  # validations do
  #   validate(one_of(:status, ["new", "investigating", "closed"]))
  # end

  @derive {Phoenix.Param, key: :rowid}
  @primary_key {:rowid, :integer, []}
  attributes do
    attribute :rowid, :integer do
      primary_key?(true)
    end

    attribute(:guid, :string)

    # ==========================================================================
    # Room
    # ==========================================================================
    attribute :chat_identifier, :string
    attribute :display_name, :string
    attribute :group_id, :string
    attribute :original_group_id, :string
    attribute :room_name, :string

    # ==========================================================================
    # Boolean (INTEGER)
    # ==========================================================================
    # attribute :is_filtered, :integer, constraints: Types.constraints(:boolean_int)
    # attribute :is_archived, :integer, constraints: Types.constraints(:boolean_int), default: 0

    # ==========================================================================
    # Dates (INTEGER)
    # ==========================================================================
    attribute(:last_read_message_timestamp, :integer) do
      description """
      Datetime when the last message in the was read.
      When this is `0` it was never set and should be viewed as `nil`.
      """

      constraints Types.constraints(:unix_timestamp)
      default 0
    end

    # ==========================================================================
    # Integers (INTEGER)
    # ==========================================================================
    # attribute :ck_sync_state, :integer, default: 0
    # attribute :sr_ck_sync_state, :integer, default: 0
    # attribute :state, :integer
    attribute :style, :integer
    # attribute :successful_query, :integer

    # ==========================================================================
    # Other (TEXT)
    # ==========================================================================
    # attribute :account_id, :string
    # attribute :account_login, :string
    # attribute :cloudkit_record_id, :string
    # attribute :engram_id, :string
    attribute :last_addressed_handle, :string
    # attribute :server_change_token, :string
    # attribute :service_name, :string
    # attribute :sr_cloudkit_record_id, :string
    # attribute :sr_server_change_token, :string

    # ==========================================================================
    # Other (BLOB)
    # ==========================================================================
    # attribute :properties, :string
  end

  # calculations do
  #   calculate(
  #     :conversation_name,
  #     concat([:chat_identifier, :display_name, :group_id, :room_name], " ")
  #   )
  # end

  # aggregates do
  #   count(:total_message_count, [:in_chat_messages])
  #   # count(:total_message_count, [:in_chat_messages], filter: [blank: false])
  #   # count(:open_chat_count, [:assigned_chats], filter: [not: [status: "closed"]])
  # end

  relationships do
    belongs_to(:handle_last_addressed, Handle) do
      source_field :last_addressed_handle
      field_type :string
      destination_field :id
    end

    many_to_many(:handles, Handle) do
      source_field(:rowid)
      destination_field(:rowid)
      source_field_on_join_table(:chat_id)
      destination_field_on_join_table(:handle_id)
      join_relationship(:chat_handle_join)
      through(ChatHandle)
    end

    many_to_many(:messages, Message) do
      source_field(:rowid)
      destination_field(:rowid)
      source_field_on_join_table(:chat_id)
      destination_field_on_join_table(:message_id)
      join_relationship(:chat_message_join)
      through(ChatMessage)
    end
  end

  def postgres_ddl do
    """
    create table chat
    (
      ROWID INTEGER
        primary key autoincrement,
      guid TEXT not null
        unique,
      style INTEGER,
      state INTEGER,
      account_id TEXT,
      properties BLOB,
      chat_identifier TEXT,
      service_name TEXT,
      room_name TEXT,
      account_login TEXT,
      is_archived INTEGER default 0,
      last_addressed_handle TEXT,
      display_name TEXT,
      group_id TEXT,
      is_filtered INTEGER,
      successful_query INTEGER,
      engram_id TEXT,
      server_change_token TEXT,
      ck_sync_state INTEGER default 0,
      original_group_id TEXT,
      last_read_message_timestamp INTEGER default 0,
      sr_server_change_token TEXT,
      sr_ck_sync_state INTEGER default 0,
      cloudkit_record_id TEXT,
      sr_cloudkit_record_id TEXT
    );

    create index chat_idx_chat_identifier
      on chat (chat_identifier);

    create index chat_idx_chat_identifier_service_name
      on chat (chat_identifier, service_name);

    create index chat_idx_chat_room_name_service_name
      on chat (room_name, service_name);

    create index chat_idx_is_archived
      on chat (is_archived);

    CREATE TRIGGER after_delete_on_chat AFTER DELETE ON chat BEGIN DELETE FROM chat_message_join WHERE chat_id = OLD.ROWID; END;
    """
  end
end
