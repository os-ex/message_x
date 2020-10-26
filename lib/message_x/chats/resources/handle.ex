defmodule MessageX.Chats.Handle do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    authorizers: [
      AshPolicyAuthorizer.Authorizer
    ],
    extensions: [
      AshJsonApi.Resource,
      AshGraphql.Resource
    ]

  # resource do
  #   base_filter(message: true)

  #   identities do
  #     identity(:message_name, [:first_name, :last_name])
  #   end
  # end

  postgres do
    table("handle")
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
    attribute :id, :string do
      primary_key?(true)
    end

    attribute(:rowid, :integer)
    attribute(:country, :string)
    attribute(:service, :string)
    attribute(:uncanonicalized_id, :string)
  end

  # aggregates do
  #   count(:open_chat_count, [:assigned_chats], filter: [not: [status: "closed"]])
  # end

  # calculations do
  #   calculate(:full_name, concat([:first_name, :last_name], " "))
  # end

  # relationships do
  #   has_many :assigned_chats, MessageX.Chats.Chat do
  #     destination_field(:message_id)
  #   end
  # end
end
