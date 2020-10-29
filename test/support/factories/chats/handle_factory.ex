defmodule MessageX.Factories.Chats.HandleFactory do
  @moduledoc """
  Factory for `MessageX.Chats.Handle` structs.
  """

  alias MessageX.Support.Randoms

  alias MessageX.Chats.Handle

  defmacro __using__(_opts) do
    quote do
      def handle_create_mutation_factory do
        %{
          rowid: Randoms.random(:primary_key),
          guid: Randoms.random(:guid, :string),
          country: Randoms.random(:country, :string),
          service: Randoms.random(:service, :string),
          uncanonicalized_id: Randoms.random(:uncanonicalized_id, :string)
        }
      end

      def handle_factory do
        struct(Handle, handle_create_mutation_factory())
      end
    end
  end
end
