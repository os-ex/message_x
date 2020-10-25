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
      AshGraphql.Resource,
      AshJsonApi.Resource
    ]

  pub_sub do
    # A prefix for all messages
    prefix("chat")
    # The module to call `broadcast/3` on
    module(MessageXWeb.Endpoint)

    # When a chat is assigned, publish chat:assigned_to:<message_id>
    publish(:assign, ["assigned_to", :message_id])
    publish_all(:update, ["updated", :message_id])
    publish_all(:update, ["updated", :reporter_id])
  end

  graphql do
    type(:chat)

    fields([:subject, :description, :response, :status, :reporter])

    queries do
      get(:get_chat, :read)
      list(:list_chats, :read)
    end

    mutations do
      create(:open_chat, :open)
      update(:update_chat, :update)
      destroy(:destroy_chat, :destroy)
    end
  end

  json_api do
    type("chat")

    routes do
      base("/chats")

      get(:read)
      index(:reported, route: "/reported")
      index(:read)
      post(:open, route: "/open")
      patch(:update)
      delete(:destroy)
    end

    fields([:subject, :description, :response, :status, :reporter])

    includes([
      :reporter
    ])
  end

  policies do
    bypass always() do
      authorize_if(actor_attribute_equals(:admin, true))
    end

    policy action_type(:read) do
      authorize_if(actor_attribute_equals(:message, true))
      authorize_if(relates_to_actor_via(:reporter))
    end

    policy changing_relationship(:reporter) do
      authorize_if(relating_to_actor(:reporter))
    end
  end

  actions do
    read :reported do
      filter(reporter: actor(:id))

      pagination(offset?: true, countable: true, required?: false)
    end

    read :assigned do
      filter(message: actor(:id))
      pagination(offset?: true, countable: true, required?: false)
    end

    read :read do
      primary?(true)
    end

    create :open do
      accept([:subject, :reporter])
    end

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

  validations do
    validate(one_of(:status, ["new", "investigating", "closed"]))
  end

  attributes do
    attribute :id, :uuid do
      primary_key?(true)
      default(&Ecto.UUID.generate/0)
    end

    attribute :subject, :string do
      allow_nil?(false)
      constraints(min_length: 5)
    end

    attribute(:description, :string)

    attribute(:response, :string)

    attribute :status, :string do
      allow_nil?(false)
      default("new")
    end
  end

  relationships do
    belongs_to :reporter, MessageX.Chats.Attachment

    belongs_to :message, MessageX.Chats.Message
  end
end
