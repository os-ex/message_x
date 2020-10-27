defmodule MessageX.Factories.Chats.MessageFactory do
  @moduledoc """
  Factory for `MessageX.Chats.Message` structs.
  """

  alias MessageX.Support.Randoms

  alias MessageX.Chats.Message

  defmacro __using__(_opts) do
    quote do
      def message_create_mutation_factory do
        %{}
      end

      def message_factory do
        build(:random_message)
      end

      def random_message_factory do
        %Message{
          rowid: Randoms.random(:primary_key),
          is_from_me: Randoms.random(:is_from_me, :boolean_int),
          is_audio_message: Randoms.random(:is_audio_message, :boolean_int),
          service: Randoms.random(:service, :string),
          subject: Randoms.random(:subject, :string),
          is_delayed: Randoms.random(:is_delayed, :boolean_int),
          guid: Randoms.random(:guid, :string),
          group_title: Randoms.random(:group_title, :string),
          has_dd_results: Randoms.random(:has_dd_results, :integer),
          account: Randoms.random(:account, :string),
          date_read: Randoms.random(:date_read, :unix_date_integer),
          is_sent: Randoms.random(:is_sent, :boolean_int),
          country: Randoms.random(:country, :string),
          item_type: Randoms.random(:item_type, :integer),
          is_delivered: Randoms.random(:is_delivered, :boolean_int),
          type: Randoms.random(:type, :integer),
          is_auto_reply: Randoms.random(:is_auto_reply, :boolean_int),
          service_center: Randoms.random(:service_center, :string),
          is_expirable: Randoms.random(:is_expirable, :boolean_int),
          is_played: Randoms.random(:is_played, :boolean_int),
          date_delivered: Randoms.random(:date_delivered, :unix_date_integer),
          was_deduplicated: Randoms.random(:was_deduplicated, :integer),
          was_data_detected: Randoms.random(:was_data_detected, :integer),
          error: Randoms.random(:error, :integer),
          date_played: Randoms.random(:date_played, :unix_date_integer),
          was_downgraded: Randoms.random(:was_downgraded, :integer),
          message_source: Randoms.random(:message_source, :integer),
          account_guid: Randoms.random(:account_guid, :string),
          replace: Randoms.random(:replace, :integer),
          is_service_message: Randoms.random(:is_service_message, :boolean_int),
          cache_roomnames: Randoms.random(:cache_roomnames, :string),
          expire_state: Randoms.random(:expire_state, :integer),
          share_status: Randoms.random(:share_status, :integer),
          group_action_type: Randoms.random(:group_action_type, :integer),
          cache_has_attachments: Randoms.random(:cache_has_attachments, :integer),
          is_read: Randoms.random(:is_read, :boolean_int),
          other_handle: Randoms.random(:other_handle, :integer),
          is_emote: Randoms.random(:is_emote, :boolean_int),
          # # attributedbody: Randoms.random(:attributedbody, :binary),
          message_action_type: Randoms.random(:message_action_type, :integer),
          is_forward: Randoms.random(:is_forward, :boolean_int),
          is_finished: Randoms.random(:is_finished, :boolean_int),
          date: Randoms.random(:date, :unix_date_integer),
          is_empty: Randoms.random(:is_empty, :boolean_int),
          is_prepared: Randoms.random(:is_prepared, :boolean_int),
          text: Randoms.random(:text, :string),
          is_system_message: Randoms.random(:is_system_message, :boolean_int),
          version: Randoms.random(:version, :integer),
          share_direction: Randoms.random(:share_direction, :integer),
          is_archive: Randoms.random(:is_archive, :boolean_int)
        }
      end

      def random_message_with_assocs_factory do
        build(:random_message,
          handle: build(:random_handle)
        )
      end
    end
  end
end
