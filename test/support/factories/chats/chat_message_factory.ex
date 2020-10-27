defmodule MessageX.Factories.Chats.ChatMessageFactory do
  @moduledoc """
  Factory for `MessageX.Chats.ChatMessage` structs.
  """

  alias MessageX.Support.Randoms

  alias MessageX.Chats.ChatMessage

  defmacro __using__(_opts) do
    quote do
      def chat_message_create_mutation_factory do
        %{
          chat_id: Randoms.random(:primary_key),
          message_id: Randoms.random(:primary_key)
          # chat: params_for(:chat_create_mutation),
          # message: params_for(:message_create_mutation)
        }
      end

      def chat_message_factory do
        build(:random_chat_message)
      end

      def random_chat_message_factory do
        %ChatMessage{}
      end

      def random_chat_message_with_assocs_factory do
        build(:random_chat_message,
          chat: build(:random_chat),
          message: build(:random_message)
        )
      end
    end
  end
end
