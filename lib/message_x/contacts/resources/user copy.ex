defmodule Helpdesk.Accounts.User do
  alias AshPostgres.DataLayer
  alias AshPolicyAuthorizer.Authorizer
  alias Ash.Notifier.PubSub

  use Ash.Resource,
    data_layer: AshPostgres,
    authorizers: [AshPolicyAuthorizer],
    notifiers: [Ash.Notifier.PubSub],
    extensions: [AshJsonApi.Resource, AshGraphql.Resource]

  pub_sub do
    module(HelpdeskWeb.Endpoint)

    publish(:update) do
      fields(["updated", :id])
    end
  end

  graphql(:infer) do
    queries do
      get(:get_user, :me)
    end

    mutations(except: [:delete])
  end

  json_api :infer do
    routes do
      get(:me, route: "/me")
    end
  end

  policies do
    bypass always() do
      authorize_if(actor_attribute_equals(:admin, true))
    end

    policy action_type(:read) do
      authorize_if(attribute(:id, eq: actor(:id)))
    end
  end

  actions :infer do
    read(:me, filter: [id: actor(:id)])
  end

  postgres :infer do
    repo(Helpdesk.Repo)
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

    attribute :representative, :boolean do
      allow_nil?(false)
      default(false)
    end

    attribute :admin, :boolean do
      allow_nil?(false)
      default(false)
    end
  end
end
