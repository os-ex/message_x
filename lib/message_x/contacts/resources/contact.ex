defmodule MessageX.Contacts.Contact do
  @moduledoc """
  Ash resource for attachments.
  """

  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    authorizers: [
      # AshPolicyAuthorizer.Authorizer
    ],
    notifiers: [
      Ash.Notifier.PubSub
    ],
    extensions: [
      # AshJsonApi.Resource,
      # AshGraphql.Resource
    ]

  pub_sub do
    prefix("contact")

    module(MessageXWeb.Endpoint)

    publish(:update, ["updated", :id])
  end

  # graphql do
  #   type(:contact)

  #   fields([:first_name, :last_name, :message, :admin])

  #   queries do
  #     get(:get_contact, :me)
  #   end

  #   mutations do
  #     create(:create_contact, :create)
  #     update(:update_contact, :update)
  #     destroy(:destroy_contact, :destroy)
  #   end
  # end

  # json_api do
  #   type("contact")

  #   routes do
  #     base("/contacts")

  #     get(:me, route: "/me")
  #     index(:read)
  #     post(:create)
  #     patch(:update)
  #     delete(:destroy)
  #   end

  #   fields([:first_name, :last_name, :message, :admin])
  # end

  # policies do
  #   bypass always() do
  #     authorize_if(actor_attribute_equals(:admin, true))
  #   end

  #   policy action_type(:read) do
  #     authorize_if(attribute(:id, eq: actor(:id)))
  #   end
  # end

  actions do
    read(:me, filter: [id: actor(:id)])
    read(:read, primary?: true)
    create(:create)
    update(:update)
    destroy(:destroy)
  end

  postgres do
    table("contacts")
    repo(MessageX.Repo)
  end

  validations do
    validate(present([:first_name, :last_name], at_least: 1))
  end

  attributes do
    attribute :id, :uuid do
      primary_key?(true)
      default(&Ecto.UUID.generate/0)
    end

    attribute :first_name, :string do
      constraints(min_length: 1)
    end

    attribute :last_name, :string do
      constraints(min_length: 1)
    end

    attribute :message, :boolean do
      allow_nil?(false)
      default(false)
    end

    attribute :admin, :boolean do
      allow_nil?(false)
      default(false)
    end
  end
end
