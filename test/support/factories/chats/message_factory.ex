defmodule MessageX.Factories.Chats.MessageFactory do
  @moduledoc """
  Factory for `MessageX.Chats.Message` structs.
  """

  alias MessageX.Support.Randoms

  alias MessageX.Chats.Message

  defmacro __using__(_opts) do
    quote do
      def message_create_mutation_factory do
        %{
          account_guid: Randoms.random(:account_guid, :string),
          account: Randoms.random(:account, :string),
          associated_message_guid: Randoms.random(:associated_message_guid, :string),
          associated_message_range_length:
            Randoms.random(:associated_message_range_length, :pos_integer),
          associated_message_range_location:
            Randoms.random(:associated_message_range_location, :integer),
          associated_message_type: Randoms.random(:associated_message_type, :integer),
          attributedBody: Randoms.random(:attributedBody, :string),
          balloon_bundle_id: Randoms.random(:balloon_bundle_id, :string),
          cache_has_attachments: Randoms.random(:cache_has_attachments, :boolean_int),
          cache_roomnames: Randoms.random(:cache_roomnames, :string),
          ck_record_change_tag: Randoms.random(:ck_record_change_tag, :string),
          ck_record_id: Randoms.random(:ck_record_id, :string),
          ck_sync_state: Randoms.random(:ck_sync_state, :integer),
          country: Randoms.random(:country, :string),
          date_delivered: Randoms.random(:date_delivered, :unix_date_integer),
          date_played: Randoms.random(:date_played, :unix_date_integer),
          date_read: Randoms.random(:date_read, :unix_date_integer),
          date: Randoms.random(:date, :unix_date_integer),
          destination_caller_id: Randoms.random(:destination_caller_id, :string),
          error: Randoms.random(:error, :integer),
          expire_state: Randoms.random(:expire_state, :integer),
          expressive_send_style_id: Randoms.random(:expressive_send_style_id, :string),
          group_action_type: Randoms.random(:group_action_type, :integer),
          group_title: Randoms.random(:group_title, :string),
          guid: Randoms.random(:guid, :string),
          has_dd_results: Randoms.random(:has_dd_results, :integer),
          is_archive: Randoms.random(:is_archive, :integer),
          is_audio_message: Randoms.random(:is_audio_message, :integer),
          is_auto_reply: Randoms.random(:is_auto_reply, :integer),
          is_delayed: Randoms.random(:is_delayed, :integer),
          is_delivered: Randoms.random(:is_delivered, :boolean_int),
          is_emote: Randoms.random(:is_emote, :integer),
          is_empty: Randoms.random(:is_empty, :integer),
          is_expirable: Randoms.random(:is_expirable, :integer),
          is_finished: Randoms.random(:is_finished, :integer),
          is_forward: Randoms.random(:is_forward, :integer),
          is_from_me: Randoms.random(:is_from_me, :boolean_int),
          is_played: Randoms.random(:is_played, :integer),
          is_prepared: Randoms.random(:is_prepared, :integer),
          is_read: Randoms.random(:is_read, :boolean_int),
          is_sent: Randoms.random(:is_sent, :boolean_int),
          is_service_message: Randoms.random(:is_service_message, :integer),
          is_system_message: Randoms.random(:is_system_message, :integer),
          item_type: Randoms.random(:item_type, :integer),
          message_action_type: Randoms.random(:message_action_type, :integer),
          message_source: Randoms.random(:message_source, :integer),
          message_summary_info: Randoms.random(:message_summary_info, :string),
          payload_data: Randoms.random(:payload_data, :string),
          replace: Randoms.random(:replace, :integer),
          rowid: Randoms.random(:primary_key),
          service_center: Randoms.random(:service_center, :string),
          service: Randoms.random(:service, :string),
          share_direction: Randoms.random(:share_direction, :integer),
          share_status: Randoms.random(:share_status, :integer),
          sr_ck_record_change_tag: Randoms.random(:sr_ck_record_change_tag, :string),
          sr_ck_record_id: Randoms.random(:sr_ck_record_id, :string),
          sr_ck_sync_state: Randoms.random(:sr_ck_sync_state, :integer),
          subject: Randoms.random(:subject, :string),
          text: Randoms.random(:text, :string),
          time_expressive_send_played:
            Randoms.random(:time_expressive_send_played, :unix_date_integer),
          type: Randoms.random(:type, :integer),
          version: Randoms.random(:version, :integer),
          was_data_detected: Randoms.random(:was_data_detected, :integer),
          was_deduplicated: Randoms.random(:was_deduplicated, :integer),
          was_downgraded: Randoms.random(:was_downgraded, :integer)
        }
      end

      def message_factory do
        struct(Message, message_create_mutation_factory())
      end
    end
  end
end
