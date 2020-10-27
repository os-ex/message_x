defmodule MessageX.Chats.Chat do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    authorizers: [
      AshPolicyAuthorizer.Authorizer
    ],
    notifiers: [
      Ash.Notifier.PubSub
    ],
    extensions: [
      # AshGraphql.Resource,
      # AshJsonApi.Resource
    ]

  alias DarkMatter.DateTimes

  # alias MessageX.Ecto.BooleanInt
  # alias MessageX.Ecto.UnixDatetime

  alias MessageX.Chats.Attachment
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

  # graphql do
  #   type(:chat)

  #   fields([:subject, :description, :response, :status, :reporter])

  #   queries do
  #     get(:get_chat, :read)
  #     list(:list_chats, :read)
  #   end

  #   mutations do
  #     create(:open_chat, :open)
  #     update(:update_chat, :update)
  #     destroy(:destroy_chat, :destroy)
  #   end
  # end

  # json_api do
  #   type("chat")

  #   routes do
  #     base("/chats")

  #     get(:read)
  #     index(:reported, route: "/reported")
  #     index(:read)
  #     post(:open, route: "/open")
  #     patch(:update)
  #     delete(:destroy)
  #   end

  #   fields([:subject, :description, :response, :status, :reporter])

  #   includes([
  #     :reporter
  #   ])
  # end

  # policies do
  #   bypass always() do
  #     authorize_if(actor_attribute_equals(:admin, true))
  #   end

  #   policy action_type(:read) do
  #     authorize_if(actor_attribute_equals(:message, true))
  #     authorize_if(relates_to_actor_via(:reporter))
  #   end

  #   policy changing_relationship(:reporter) do
  #     authorize_if(relating_to_actor(:reporter))
  #   end
  # end

  actions do
    # read :reported do
    #   filter(reporter: actor(:id))

    #   pagination(offset?: true, countable: true, required?: false)
    # end

    # read :assigned do
    #   filter(message: actor(:id))
    #   pagination(offset?: true, countable: true, required?: false)
    # end

    read :read do
      primary?(true)
    end

    # create :open do
    #   accept([:subject, :reporter])
    # end

    update(:update, primary?: true)

    update :assign do
      accept([:message])
    end

    destroy(:destroy)
  end

  postgres do
    table("chats")
    repo(MessageX.Repo)
  end

  # validations do
  #   validate(one_of(:status, ["new", "investigating", "closed"]))
  # end

  @primary_key {:rowid, :integer, []}
  @derive {Phoenix.Param, key: :rowid}
  attributes do
    attribute :rowid, :integer do
      primary_key?(true)
    end

    # attribute(:rowid, :integer)
    attribute(:guid, :string)
    attribute(:account_id, :string)
    attribute(:account_login, :string)
    attribute(:chat_identifier, :string)
    attribute(:display_name, :string)
    attribute(:group_id, :string)
    # attribute(:guid, :string)
    attribute(:is_archived, :integer)
    attribute(:is_filtered, :integer)
    attribute(:last_addressed_handle, :string)
    # attribute(:properties, :binary)
    attribute(:room_name, :string)
    attribute(:service_name, :string)
    attribute(:state, :integer)
    attribute(:style, :integer)
    attribute(:successful_query, :integer)

    # New
    attribute(:last_read_message_timestamp, :integer)

    # attribute(:is_online, :boolean, virtual: true, default: false)
    # attribute(:avatars, {:array, :string}, virtual: true, default: [])
    # attribute(:identifiers, :string, virtual: true)
    # attribute(:unread_count, :integer, default: 0, virtual: true)
    # attribute(:last_message_at, :utc_datetime_usec, default: DateTimes.now!(), virtual: true)
  end

  relationships do
    many_to_many(:messages, Message) do
      source_field(:rowid)
      destination_field(:rowid)
      source_field_on_join_table(:chat_id)
      destination_field_on_join_table(:message_id)
      through(ChatMessage)
    end

    many_to_many(:handles, Attachment) do
      source_field(:rowid)
      destination_field(:rowid)
      source_field_on_join_table(:chat_id)
      destination_field_on_join_table(:handle_id)
      # join_relationship("message_attachment")
      through(ChatHandle)
    end
  end
end
