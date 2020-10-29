defmodule MessageX.Factories.Chats.AttachmentFactory do
  @moduledoc """
  Factory for `MessageX.Chats.Attachment` structs.
  """

  alias MessageX.Support.Randoms

  alias MessageX.Chats.Attachment

  defmacro __using__(_opts) do
    quote do
      def attachment_create_mutation_factory do
        %{
          rowid: Randoms.random(:rowid, :integer),
          guid: Randoms.random(:guid, :string),
          filename: Randoms.random(:filename, :string),
          uti: Randoms.random(:uti, :string),
          mime_type: Randoms.random(:mime_type, :string),
          total_bytes: Randoms.random(:total_bytes, :pos_integer),
          transfer_name: Randoms.random(:transfer_name, :string),
          hide_attachment: Randoms.random(:hide_attachment, :boolean_int),
          created_date: Randoms.random(:created_date, :unix_date_integer),
          start_date: Randoms.random(:start_date, :unix_date_integer)
        }
      end

      def attachment_factory do
        struct(Attachment, attachment_create_mutation_factory())
      end
    end
  end
end
