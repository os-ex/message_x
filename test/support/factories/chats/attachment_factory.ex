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
          # created_date: Randoms.random(:created_date, :utc_datetime_usec),
          filename: Randoms.random(:filename, :string),
          guid: Randoms.random(:guid, :string),
          # is_outgoing: Randoms.random(:is_outgoing, :integer),
          mime_type: Randoms.random(:mime_type, :string),
          # start_date: Randoms.random(:start_date, :utc_datetime_usec),
          total_bytes: Randoms.random(:total_bytes, :integer),
          transfer_name: Randoms.random(:transfer_name, :string)
          # transfer_state: Randoms.random(:transfer_state, :integer),
          # user_info: Randoms.random(:user_info, :binary),
          # uti: Randoms.random(:uti, :string)
        }
      end

      def attachment_factory do
        build(:random_attachment)
      end

      def random_attachment_factory do
        %Attachment{
          # created_date: Randoms.random(:created_date, :utc_datetime_usec),
          filename: Randoms.random(:filename, :string),
          guid: Randoms.random(:guid, :string),
          # is_outgoing: Randoms.random(:is_outgoing, :integer),
          mime_type: Randoms.random(:mime_type, :string),
          # start_date: Randoms.random(:start_date, :utc_datetime_usec),
          total_bytes: Randoms.random(:total_bytes, :integer),
          transfer_name: Randoms.random(:transfer_name, :string)
          # transfer_state: Randoms.random(:transfer_state, :integer),
          # user_info: Randoms.random(:user_info, :binary),
          # uti: Randoms.random(:uti, :string)
        }
      end

      def random_attachment_with_assocs_factory do
        build(:random_attachment, [])
      end
    end
  end
end
