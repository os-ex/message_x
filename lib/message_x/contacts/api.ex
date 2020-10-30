defmodule MessageX.Contacts.Api do
  use Ash.Api,
    extensions: [
      # AshJsonApi.Api,
      # AshGraphql.Api
    ]

  # graphql do
  #   authorize?(true)
  # end

  resources do
    resource(MessageX.Contacts.Contact)
  end
end
