defmodule MessageX.Factories.Chats.ChatFactory do
  @moduledoc """
  Factory for `MessageX.Chats.Chat` structs.
  """

  alias MessageX.Support.Randoms

  alias MessageX.Chats.Chat

  defmacro __using__(_opts) do
    quote do
      def chat_create_mutation_factory do
        %{
          rowid: Randoms.random(:rowid, :integer),
          guid: Randoms.random(:guid, :string),
          chat_identifier: Randoms.random(:chat_identifier, :string),
          display_name: Randoms.random(:display_name, :string),
          group_id: Randoms.random(:group_id, :string),
          original_group_id: Randoms.random(:original_group_id, :string),
          room_name: Randoms.random(:room_name, :string),
          is_filtered: Randoms.random(:is_filtered, :boolean_int),
          is_archived: Randoms.random(:is_archived, :boolean_int),
          last_read_message_timestamp:
            Randoms.random(:last_read_message_timestamp, :unix_date_integer),
          ck_sync_state: Randoms.random(:ck_sync_state, :integer),
          sr_ck_sync_state: Randoms.random(:sr_ck_sync_state, :integer),
          state: Randoms.random(:state, :integer),
          style: Randoms.random(:style, :integer),
          successful_query: Randoms.random(:successful_query, :integer),
          account_id: Randoms.random(:account_id, :string),
          account_login: Randoms.random(:account_login, :string),
          cloudkit_record_id: Randoms.random(:cloudkit_record_id, :string),
          engram_id: Randoms.random(:engram_id, :string),
          last_addressed_handle: Randoms.random(:last_addressed_handle, :string),
          server_change_token: Randoms.random(:server_change_token, :string),
          service_name: Randoms.random(:service_name, :string),
          sr_cloudkit_record_id: Randoms.random(:sr_cloudkit_record_id, :string),
          sr_server_change_token: Randoms.random(:sr_server_change_token, :string),
          properties: Randoms.random(:properties, :string)
        }
      end

      def chat_factory do
        build(:random_chat)
      end

      def random_chat_factory do
        struct(Chat, chat_create_mutation_factory())
      end

      def random_chat_with_assocs_factory do
        build(:random_chat, [])
      end
    end
  end
end
