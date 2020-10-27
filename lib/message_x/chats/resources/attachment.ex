defmodule MessageX.Chats.Attachment do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    authorizers: [
      AshPolicyAuthorizer.Authorizer
    ],
    extensions: [
      AshJsonApi.Resource
    ]

  # resource do
  #   base_filter(message: false)
  # end

  # json_api do
  #   type("attachment")

  #   routes do
  #     base("/attachments")

  #     get(:read)
  #     index(:read)
  #   end

  #   fields([:first_name, :last_name])
  # end

  postgres do
    table("attachment")
    repo(MessageX.Repo)
  end

  # policies do
  #   bypass always() do
  #     authorize_if(actor_attribute_equals(:admin, true))
  #   end

  #   policy action_type(:read) do
  #     authorize_if(attribute(:id, not: [eq: actor(:id)]))
  #     authorize_if(relates_to_actor_via([:reported_chats, :message]))
  #   end
  # end

  actions do
    read(:read)
  end

  attributes do
    attribute :id, :integer do
      # name(:rowid)
      primary_key?(true)
    end

    attribute(:rowid, :string)
    attribute(:guid, :string)
    attribute(:filename, :string)
    attribute(:transfer_name, :string)
    attribute(:mime_type, :string)
    attribute(:total_bytes, :integer)
    attribute(:hide_attachment, :integer)
    attribute(:created_date, :integer)
  end

  # relationships do
  #   has_many :reported_chats, MessageX.Chats.Chat do
  #     destination_field(:chat_id)
  #   end
  # end
end
