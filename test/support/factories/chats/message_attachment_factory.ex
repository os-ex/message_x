defmodule MessageX.Factories.Chats.MessageAttachmentFactory do
  @moduledoc """
  Factory for `MessageX.Chats.MessageAttachment` structs.
  """

  alias MessageX.Support.Randoms

  alias MessageX.Chats.MessageAttachment

  defmacro __using__(_opts) do
    quote do
      def message_attachment_create_mutation_factory do
        %{
          message_id: Randoms.random(:primary_key),
          attachment_id: Randoms.random(:primary_key)
        }
      end

      def message_attachment_factory do
        struct(MessageAttachment, message_attachment_create_mutation_factory())
      end
    end
  end
end
