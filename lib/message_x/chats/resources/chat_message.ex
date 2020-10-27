defmodule MessageX.Chats.ChatMessage do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    authorizers: [
      AshPolicyAuthorizer.Authorizer
    ],
    extensions: [
      # AshJsonApi.Resource,
      # AshGraphql.Resource
    ]

  alias MessageX.Chats.Message
  alias MessageX.Chats.Chat
  alias MessageX.Chats.Attachment
  # resource do
  #   base_filter(chat: true)

  #   identities do
  #     identity(:chat_name, [:first_name, :last_name])
  #   end
  # end

  postgres do
    table("chat_message")
    repo(MessageX.Repo)
    # base_filter_sql("chat = true")
  end

  # graphql do
  #   type(:chat)

  #   fields([:first_name, :last_name, :open_chat_count, :assigned_chats])

  #   queries do
  #     get(:get_chat, :read)
  #     list(:list_chats, :read)
  #   end
  # end

  # json_api do
  #   type("chat")

  #   routes do
  #     base("/chats")

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

  #   policy action_type(:read) do
  #     authorize_if(actor_attribute_equals(:chat, true))
  #     authorize_if(relates_to_actor_via([:assigned_chats, :reporter]))
  #   end
  # end

  # actions do
  #   read :read do
  #     primary?(true)
  #   end

  #   read :me do
  #     filter(id: actor(:id))
  #   end
  # end

  @primary_key false
  attributes do
    attribute :id, :integer do
      primary_key?(true)
    end

    attribute(:chat_id, :integer)
    attribute(:message_id, :integer)
  end

  # aggregates do
  #   count(:open_chat_count, [:assigned_chats], filter: [not: [status: "closed"]])
  # end

  # calculations do
  #   calculate(:full_name, concat([:first_name, :last_name], " "))
  # end

  relationships do
    belongs_to :chat, Chat, destination_field: :rowid
    belongs_to :message, Message, destination_field: :rowid
  end
end
