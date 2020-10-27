defmodule MessageX.Factories.Chats.ChatHandleFactory do
  @moduledoc """
  Factory for `MessageX.Chats.ChatHandle` structs.
  """

  alias MessageX.Support.Randoms

  alias MessageX.Chats.ChatHandle

  defmacro __using__(_opts) do
    quote do
      def chat_handle_create_mutation_factory do
        %{
          chat_id: Randoms.random(:primary_key),
          handle_id: Randoms.random(:guid)
          # chat: params_for(:chat_create_mutation),
          # handle: params_for(:handle_create_mutation)
        }
      end

      def chat_handle_factory do
        build(:random_chat_handle)
      end

      def random_chat_handle_factory do
        %ChatHandle{}
      end

      def random_chat_handle_with_assocs_factory do
        build(:random_chat_handle,
          chat: build(:random_chat),
          handle: build(:random_handle)
        )
      end
    end
  end
end
