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
          handle_id: Randoms.random(:primary_key)
        }
      end

      def message_attachment_factory do
        struct(ChatHandle, chat_handle_create_mutation_factory())
      end
    end
  end
end
