defmodule MessageX.Chats.Message do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    authorizers: [
      # AshPolicyAuthorizer.Authorizer
    ],
    extensions: [
      # AshJsonApi.Resource,
      # AshGraphql.Resource
    ]

  alias MessageX.Chats.Attachment
  alias MessageX.Chats.Chat
  alias MessageX.Chats.Handle
  alias MessageX.Chats.MessageAttachment
  alias MessageX.Chats.ChatMessage

  # resource do
  #   base_filter(message: true)

  #   identities do
  #     identity(:message_name, [:first_name, :last_name])
  #   end
  # end

  postgres do
    table("message")
    repo(MessageX.Repo)
    # base_filter_sql("message = true")
  end

  # graphql do
  #   type(:message)

  #   fields([:first_name, :last_name, :open_chat_count, :assigned_chats])

  #   queries do
  #     get(:get_message, :read)
  #     list(:list_messages, :read)
  #   end
  # end

  # json_api do
  #   type("message")

  #   routes do
  #     base("/messages")

  #     get(:me, route: "/me")
  #     get(:read)
  #     index(:read)
  #   end

  #   fields([:first_name, :last_name, :open_chat_count])
  # end

  # policies do
  #   bypass always() do
  #     authorize_if(actor_attribute_equals(:admin, true))
  #   end

  #   # policy action_type(:read) do
  #   #   authorize_if(actor_attribute_equals(:message, true))
  #   #   authorize_if(relates_to_actor_via([:assigned_chats, :reporter]))
  #   # end
  # end

  actions do
    read :read do
      primary?(true)
    end

    read :index
  end

  @primary_key {:rowid, :integer, []}
  @derive {Phoenix.Param, key: :rowid}
  attributes do
    attribute :rowid, :integer do
      primary_key?(true)
    end

    # attribute(:rowid, :integer)
    attribute(:is_from_me, :integer)
    attribute(:is_audio_message, :integer)
    attribute(:service, :string)
    attribute(:subject, :string)
    attribute(:is_delayed, :integer)
    attribute(:guid, :string)
    attribute(:group_title, :string)
    attribute(:has_dd_results, :integer)
    attribute(:account, :string)
    attribute(:date_read, :integer)
    attribute(:is_sent, :integer)
    attribute(:country, :string)
    attribute(:item_type, :integer)
    attribute(:is_delivered, :integer)
    attribute(:type, :integer)
    attribute(:is_auto_reply, :integer)
    attribute(:service_center, :string)
    attribute(:is_expirable, :integer)
    attribute(:is_played, :integer)
    attribute(:date_delivered, :integer)
    attribute(:was_deduplicated, :integer)
    attribute(:was_data_detected, :integer)
    attribute(:error, :integer)
    attribute(:date_played, :integer)
    attribute(:was_downgraded, :integer)
    attribute(:message_source, :integer)
    attribute(:account_guid, :string)
    attribute(:replace, :integer)
    attribute(:is_service_message, :integer)
    attribute(:cache_roomnames, :string)
    attribute(:expire_state, :integer)
    attribute(:share_status, :integer)
    attribute(:group_action_type, :integer)
    attribute(:cache_has_attachments, :integer)
    attribute(:is_read, :integer)
    attribute(:other_handle, :integer)
    attribute(:is_emote, :integer)
    # attribute(:attributedbody, :binary, load_in_query: false)
    attribute(:message_action_type, :integer)
    attribute(:is_forward, :integer)
    attribute(:is_finished, :integer)
    attribute(:date, :integer)
    attribute(:is_empty, :integer)
    attribute(:is_prepared, :integer)
    attribute(:text, :string)
    attribute(:is_system_message, :integer)
    attribute(:version, :integer)
    attribute(:share_direction, :integer)
    attribute(:is_archive, :integer)
    # attribute(:message_text, :string, virtual: true, default: "")
    # attribute(:attachments?, :boolean, virtual: true, default: false)
  end

  aggregates do
    count(:open_chat_count, [:assigned_chats])
    # count(:open_chat_count, [:assigned_chats], filter: [not: [status: "closed"]])
  end

  # calculations do
  #   calculate(:full_name, concat([:first_name, :last_name], " "))
  # end

  @primary_key {:rowid, :integer, []}
  @derive {Phoenix.Param, key: :rowid}
  relationships do
    # has_many :assigned_chats, MessageX.Chats.Chat do
    #   destination_field(:message_id)
    # end

    belongs_to(:handle, Handle, destination_field: :rowid, field_type: :integer)

    # many_to_many(:chats, Chat) do
    #   source_field(:rowid)
    #   destination_field(:rowid)
    #   source_field_on_join_table(:message_id)
    #   destination_field_on_join_table(:chat_id)
    #   through(ChatMessage)
    # end

    many_to_many(:attachments, Attachment) do
      source_field(:rowid)
      destination_field(:rowid)
      source_field_on_join_table(:message_id)
      destination_field_on_join_table(:attachment_id)
      through(MessageAttachment)
    end
  end
end
