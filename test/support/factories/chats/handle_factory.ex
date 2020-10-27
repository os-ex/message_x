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
          country: Randoms.random(:country, :string),
          id: Randoms.random(:id, :string),
          service: Randoms.random(:service, :string),
          uncanonicalized_id: Randoms.random(:uncanonicalized_id, :string)
        }
      end

      def handle_factory do
        build(:random_handle)
      end

      def random_handle_factory do
        %Handle{
          country: Randoms.random(:country, :string),
          id: Randoms.random(:id, :string),
          service: Randoms.random(:service, :string),
          uncanonicalized_id: Randoms.random(:uncanonicalized_id, :string)
        }
      end

      def random_handle_with_assocs_factory do
        build(:random_handle, [])
      end
    end
  end
end
