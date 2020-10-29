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
        }
      end

      def message_attachment_factory do
        struct(ChatMessage, chat_message_create_mutation_factory())
      end
    end
  end
end
