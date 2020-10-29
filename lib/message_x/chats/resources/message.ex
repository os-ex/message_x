defmodule MessageX.Chats.Message do
  @moduledoc """
    Ash resource for messages.
  """

  use Ash.Resource, data_layer: AshPostgres.DataLayer

  alias MessageX.Types

  alias MessageX.Chats.Attachment
  alias MessageX.Chats.ChatMessage
  alias MessageX.Chats.Handle
  alias MessageX.Chats.MessageAttachment

  # resource do
  #   base_filter(
  #     not: [
  #       or: [
  #         [text: "￼"],
  #         [is_nil: :text]
  #       ]
  #     ]
  #   )
  # end

  postgres do
    table("message")
    repo(MessageX.Repo)
  end

  actions do
    read :read do
      primary?(true)
    end

    read :most_recent do
      pagination(
        countable: :by_default,
        # default_limit: 5,
        # max_page_size: 20,
        offset?: true,
        keyset?: true,
        required?: true
      )
    end

    # read :most_recent do
    #   pagination(
    #     countable: :by_default,
    #     default_limit: 250,
    #     max_page_size: 250,
    #     offset?: true,
    #     keyset?: true,
    #     required?: false
    #   )
    # end

    read :in_chat do
      # filter:
      pagination(
        countable: :by_default,
        # default_limit: 250,
        # max_page_size: 250,
        offset?: true,
        keyset?: true,
        required?: true
      )
    end
  end

  @derive {Phoenix.Param, key: :rowid}
  @primary_key {:rowid, :integer, []}
  attributes do
    attribute :rowid, :integer do
      primary_key?(true)
    end

    attribute(:guid, :string) do
      description """
      Message UUID.
      """
    end

    attribute(:text, :string) do
      description """
      The message body contents
      """
    end

    # ==========================================================================
    # Room
    # ==========================================================================
    attribute(:cache_roomnames, :string)

    attribute(:group_title, :string) do
      description """
      This is a possible label on a group chat.
      """
    end

    # ==========================================================================
    # Recent Messages
    # ==========================================================================
    attribute(:associated_message_guid, :string) do
      description """
      bp:FB50CCA4-7B65-4120-BBAD-933D7EBB33FD
      p:0/009B1AEA-D01A-4DF0-9FD4-06256A0EC88E
      """

      allow_nil? true
    end

    attribute(:associated_message_range_length, :integer) do
      description """
      Number of associated messages?
      TODO: Find out what this means
      """

      constraints Types.constraints(:boolean_int)
      default 0
    end

    # ==========================================================================
    # Booleans
    # ==========================================================================

    attribute :cache_has_attachments, :integer,
      constraints: Types.constraints(:boolean_int),
      default: 0

    attribute :is_delivered, :integer, constraints: Types.constraints(:boolean_int), default: 0
    attribute :is_from_me, :integer, constraints: Types.constraints(:boolean_int), default: 0
    attribute :is_read, :integer, constraints: Types.constraints(:boolean_int), default: 0
    attribute :is_sent, :integer, constraints: Types.constraints(:boolean_int), default: 0

    # ==========================================================================
    # Dates
    # ==========================================================================
    attribute(:date, :integer) do
      description """
      Datetime when a message was sent.
      """

      constraints Types.constraints(:unix_timestamp)
    end

    attribute(:date_read, :integer) do
      description """
      Datetime when a message was read.
      When this is `0` it was never set and should be viewed as `nil`.
      """

      constraints Types.constraints(:unix_timestamp)
    end

    attribute(:date_delivered, :integer) do
      description """
      Datetime when a message was delivered.
      When this is `0` it was never set and should be viewed as `nil`.
      """

      constraints Types.constraints(:unix_timestamp)
    end

    attribute(:date_played, :integer) do
      description """
      Datetime when audio message was played.
      When this is `0` it was never set and should be viewed as `nil`.
      """

      constraints Types.constraints(:unix_timestamp)
    end

    # ==========================================================================
    # Expressive
    # ==========================================================================
    # attribute(:expressive_send_style_id, :string)
    # attribute(:time_expressive_send_played, :integer) do
    #   description """
    #   Datetime when audio espressive was played.
    #   When this is `0` it was never set and should be viewed as `nil`.
    #   """
    #   constraints Types.constraints(:unix_timestamp)
    # end

    # ==========================================================================
    # Booleans (INTEGER)
    # ==========================================================================
    # attribute :has_dd_results, :integer, constraints: Types.constraints(:boolean_int), default: 0
    # attribute :is_archive, :integer, constraints: Types.constraints(:boolean_int), default: 0
    # attribute :is_audio_message, :integer, constraints: Types.constraints(:boolean_int), default: 0
    # attribute :is_auto_reply, :integer, constraints: Types.constraints(:boolean_int), default: 0
    # attribute :is_delayed, :integer, constraints: Types.constraints(:boolean_int), default: 0
    # attribute :is_emote, :integer, constraints: Types.constraints(:boolean_int), default: 0
    # attribute :is_empty, :integer, constraints: Types.constraints(:boolean_int), default: 0
    # attribute :is_expirable, :integer, constraints: Types.constraints(:boolean_int), default: 0
    # attribute :is_finished, :integer, constraints: Types.constraints(:boolean_int), default: 0
    # attribute :is_forward, :integer, constraints: Types.constraints(:boolean_int), default: 0
    # attribute :is_played, :integer, constraints: Types.constraints(:boolean_int), default: 0
    # attribute :is_prepared, :integer, constraints: Types.constraints(:boolean_int), default: 0
    # attribute :is_service_message, :integer, constraints: Types.constraints(:boolean_int), default: 0
    # attribute :is_system_message, :integer, constraints: Types.constraints(:boolean_int), default: 0
    # attribute :was_data_detected, :integer, constraints: Types.constraints(:boolean_int), default: 0
    # attribute :was_deduplicated, :integer, constraints: Types.constraints(:boolean_int), default: 0
    # attribute :was_downgraded, :integer, constraints: Types.constraints(:boolean_int), default: 0

    # ==========================================================================
    # Other (INTEGER)
    # ==========================================================================
    # attribute :associated_message_range_location, :integer, default: 0
    # attribute :associated_message_type, :integer, default: 0
    # attribute :ck_sync_state, :integer, default: 0
    # attribute :error, :integer, default: 0
    # attribute :expire_state, :integer, default: 0
    # attribute :group_action_type, :integer, default: 0
    # attribute :item_type, :integer, default: 0
    # attribute :message_action_type, :integer, default: 0
    # attribute :message_source, :integer, default: 0
    # attribute :replace, :integer, default: 0
    # attribute :share_direction, :integer, default: 0
    # attribute :share_status, :integer, default: 0
    # attribute :sr_ck_sync_state, :integer, default: 0
    # attribute :type, :integer, default: 0
    # attribute :version, :integer, default: 0

    # ==========================================================================
    # Other (TEXT)
    # ==========================================================================
    # attribute :account_guid, :string
    # attribute :account, :string
    # attribute :balloon_bundle_id, :string
    # attribute :ck_record_change_tag, :string
    # attribute :ck_record_id, :string
    # attribute :country, :string
    # attribute :destination_caller_id, :string
    # attribute :service_center, :string
    # attribute :service, :string
    # attribute :sr_ck_record_change_tag, :string
    # attribute :sr_ck_record_id, :string
    # attribute :subject, :string

    # ==========================================================================
    # Other (BLOB)
    # ==========================================================================
    # attribute :attributedBody, :string
    # attribute :message_summary_info, :string
    # attribute :payload_data, :string
  end

  relationships do
    belongs_to(:handle, Handle) do
      field_type :integer
      destination_field :rowid
    end

    belongs_to(:handle_of_other, Handle) do
      source_field :other_handle
      field_type :integer
      destination_field :rowid
    end

    belongs_to(:chat_message, ChatMessage) do
      source_field :rowid
      field_type :integer
      destination_field :message_id
    end

    many_to_many(:attachments, Attachment) do
      source_field(:rowid)
      destination_field(:rowid)
      source_field_on_join_table(:message_id)
      destination_field_on_join_table(:attachment_id)
      through(MessageAttachment)
    end
  end

  def postgres_ddl do
    """
    create table message
    (
      ROWID INTEGER
        primary key autoincrement,
      guid TEXT not null
        unique,
      text TEXT,
      replace INTEGER default 0,
      service_center TEXT,
      handle_id INTEGER default 0,
      subject TEXT,
      country TEXT,
      attributedBody BLOB,
      version INTEGER default 0,
      type INTEGER default 0,
      service TEXT,
      account TEXT,
      account_guid TEXT,
      error INTEGER default 0,
      date INTEGER,
      date_read INTEGER,
      date_delivered INTEGER,
      is_delivered INTEGER default 0,
      is_finished INTEGER default 0,
      is_emote INTEGER default 0,
      is_from_me INTEGER default 0,
      is_empty INTEGER default 0,
      is_delayed INTEGER default 0,
      is_auto_reply INTEGER default 0,
      is_prepared INTEGER default 0,
      is_read INTEGER default 0,
      is_system_message INTEGER default 0,
      is_sent INTEGER default 0,
      has_dd_results INTEGER default 0,
      is_service_message INTEGER default 0,
      is_forward INTEGER default 0,
      was_downgraded INTEGER default 0,
      is_archive INTEGER default 0,
      cache_has_attachments INTEGER default 0,
      cache_roomnames TEXT,
      was_data_detected INTEGER default 0,
      was_deduplicated INTEGER default 0,
      is_audio_message INTEGER default 0,
      is_played INTEGER default 0,
      date_played INTEGER,
      item_type INTEGER default 0,
      other_handle INTEGER default 0,
      group_title TEXT,
      group_action_type INTEGER default 0,
      share_status INTEGER default 0,
      share_direction INTEGER default 0,
      is_expirable INTEGER default 0,
      expire_state INTEGER default 0,
      message_action_type INTEGER default 0,
      message_source INTEGER default 0,
      associated_message_guid TEXT,
      associated_message_type INTEGER default 0,
      balloon_bundle_id TEXT,
      payload_data BLOB,
      expressive_send_style_id TEXT,
      associated_message_range_location INTEGER default 0,
      associated_message_range_length INTEGER default 0,
      time_expressive_send_played INTEGER,
      message_summary_info BLOB,
      ck_sync_state INTEGER default 0,
      ck_record_id TEXT,
      ck_record_change_tag TEXT,
      destination_caller_id TEXT,
      sr_ck_sync_state INTEGER default 0,
      sr_ck_record_id TEXT,
      sr_ck_record_change_tag TEXT
    );

    create index message_idx_associated_message
      on message (associated_message_guid);

    create index message_idx_cache_has_attachments
      on message (cache_has_attachments);

    create index message_idx_date
      on message (date);

    create index message_idx_expire_state
      on message (expire_state);

    create index message_idx_failed
      on message (is_finished, is_from_me, error);

    create index message_idx_handle
      on message (handle_id, date);

    create index message_idx_handle_id
      on message (handle_id);

    create index message_idx_isRead_isFromMe_itemType
      on message (is_read, is_from_me, item_type);

    create index message_idx_is_read
      on message (is_read, is_from_me, is_finished);

    create index message_idx_other_handle
      on message (other_handle);

    create index message_idx_was_downgraded
      on message (was_downgraded);

    CREATE TRIGGER add_to_deleted_messages AFTER DELETE ON message BEGIN     INSERT INTO deleted_messages (guid) VALUES (OLD.guid); END;

    CREATE TRIGGER add_to_sync_deleted_messages AFTER DELETE ON message BEGIN     INSERT INTO sync_deleted_messages (guid, recordID) VALUES (OLD.guid, OLD.ck_record_id); END;

    CREATE TRIGGER after_delete_on_message AFTER DELETE ON message BEGIN     DELETE FROM handle         WHERE handle.ROWID = OLD.handle_id     AND         (SELECT 1 from chat_handle_join WHERE handle_id = OLD.handle_id LIMIT 1) IS NULL     AND         (SELECT 1 from message WHERE handle_id = OLD.handle_id LIMIT 1) IS NULL     AND         (SELECT 1 from message WHERE other_handle = OLD.handle_id LIMIT 1) IS NULL; END;

    CREATE TRIGGER delete_associated_messages_after_delete_on_message AFTER DELETE ON message BEGIN DELETE FROM message WHERE (OLD.associated_message_guid IS NULL AND associated_message_guid IS NOT NULL AND guid = OLD.associated_message_guid); END;

    CREATE TRIGGER update_message_date_after_update_on_message AFTER UPDATE OF date ON message BEGIN UPDATE chat_message_join SET message_date = NEW.date WHERE message_id = NEW.ROWID AND message_date != NEW.date; END;
    """
  end
end
