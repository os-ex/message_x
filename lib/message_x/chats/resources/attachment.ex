defmodule MessageX.Chats.Attachment do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    authorizers: [
      AshPolicyAuthorizer.Authorizer
    ],
    extensions: [
      AshJsonApi.Resource
    ]

  resource do
    base_filter(message: false)
  end

  json_api do
    type("attachment")

    routes do
      base("/attachments")

      get(:read)
      index(:read)
    end

    fields([:first_name, :last_name])
  end

  postgres do
    table("attachments")
    repo(MessageX.Repo)
  end

  policies do
    bypass always() do
      authorize_if(actor_attribute_equals(:admin, true))
    end

    policy action_type(:read) do
      authorize_if(attribute(:id, not: [eq: actor(:id)]))
      authorize_if(relates_to_actor_via([:reported_chats, :message]))
    end
  end

  actions do
    read(:read)
  end

  attributes do
    attribute :id, :uuid do
      primary_key?(true)
      default(&Ecto.UUID.generate/0)
    end

    attribute(:first_name, :string)
    attribute(:last_name, :string)
    attribute(:message, :boolean)
  end

  relationships do
    has_many :reported_chats, MessageX.Chats.Chat do
      destination_field(:reporter_id)
    end
  end
end
