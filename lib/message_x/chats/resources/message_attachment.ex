defmodule MessageX.Chats.MessageAttachment do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    authorizers: [
      AshPolicyAuthorizer.Authorizer
    ],
    extensions: [
      AshJsonApi.Resource,
      AshGraphql.Resource
    ]

  alias MessageX.Chats.Attachment
  alias MessageX.Chats.Message

  # resource do
  #   base_filter(message: true)

  #   identities do
  #     identity(:message_name, [:first_name, :last_name])
  #   end
  # end

  postgres do
    table("message_attachment")
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

  #   policy action_type(:read) do
  #     authorize_if(actor_attribute_equals(:message, true))
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

  attributes do
    attribute :id, :integer do
      primary_key?(true)
    end

    attribute(:message_id, :integer)
    attribute(:attachment_id, :integer)
  end

  # aggregates do
  #   count(:open_chat_count, [:assigned_chats], filter: [not: [status: "closed"]])
  # end

  # calculations do
  #   calculate(:full_name, concat([:first_name, :last_name], " "))
  # end

  relationships do
    belongs_to :message, Message
    belongs_to :attachment, Attachment
  end
end
