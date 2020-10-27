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
          # message: params_for(:message_create_mutation),
          # attachment: params_for(:attachment_create_mutation)
        }
      end

      def message_attachment_factory do
        build(:random_message_attachment)
      end

      def random_message_attachment_factory do
        %MessageAttachment{}
      end

      def random_message_attachment_with_assocs_factory do
        build(:random_message_attachment,
          message: build(:random_message),
          attachment: build(:random_attachment)
        )
      end
    end
  end
end
