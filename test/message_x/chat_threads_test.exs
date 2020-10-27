defmodule MessageX.ChatThreadsTest do
  @moduledoc false

  use MessageX.DataCase, async: true

  alias MessageX.ChatThreads

  describe ".group_messages/1" do
    test "with valid chat" do
      messages = []
      chat = build(:chat, messages: messages)
      assert ChatThreads.group_messages(chat) == []
    end

    test "with valid date and messages" do
      unix_1 = 100_000_000_000_000
      unix_2 = 200_000_000_000_000
      unix_3 = 300_000_000_000_000

      handle_1 = build(:handle)
      handle_2 = build(:handle)
      handle_3 = build(:handle)

      message_1 = build(:message, handle: handle_1, date: unix_1 + 1)
      message_2 = build(:message, handle: handle_1, date: unix_1 + 2)
      message_3 = build(:message, handle: handle_2, date: unix_1 + 3)
      message_4 = build(:message, handle: handle_1, date: unix_2 + 4)
      message_5 = build(:message, handle: handle_1, date: unix_2 + 5)
      message_6 = build(:message, handle: handle_1, date: unix_3 + 6)
      message_7 = build(:message, handle: handle_3, date: unix_3 + 7)

      chat =
        build(:chat,
          messages: [
            message_1,
            message_2,
            message_3,
            message_4,
            message_5,
            message_6,
            message_7
          ]
        )

      assert ChatThreads.group_messages(chat) == [
               {ChatThreads.cf_abs_time_to_date(unix_1),
                [
                  {handle_1, [message_1, message_2]},
                  {handle_2, [message_3]}
                ]},
               {ChatThreads.cf_abs_time_to_date(unix_2),
                [
                  {handle_1, [message_4, message_5]}
                ]},
               {ChatThreads.cf_abs_time_to_date(unix_3),
                [
                  {handle_1, [message_6]},
                  {handle_3, [message_7]}
                ]}
             ]
    end
  end

  describe ".group_date_and_messages_by_handles/1" do
    test "with valid date and empty messages" do
      date = %Date{month: 7, day: 11, year: 2020}
      messages = []
      assert ChatThreads.group_date_and_messages_by_handles({date, messages}) == {date, messages}
    end

    test "with valid date and messages" do
      unix_1 = 100_000_000_000_000
      date = ChatThreads.cf_abs_time_to_date(unix_1)
      handle_1 = build(:handle)
      handle_2 = build(:handle)

      message_1 = build(:message, handle: handle_1, date: unix_1 + 1)
      message_2 = build(:message, handle: handle_1, date: unix_1 + 2)
      message_3 = build(:message, handle: handle_2, date: unix_1 + 3)
      message_4 = build(:message, handle: handle_1, date: unix_1 + 4)
      message_5 = build(:message, handle: handle_1, date: unix_1 + 5)

      messages = [
        message_1,
        message_2,
        message_3,
        message_4,
        message_5
      ]

      assert ChatThreads.group_date_and_messages_by_handles({date, messages}) ==
               {date,
                [
                  {handle_1, [message_1, message_2]},
                  {handle_2, [message_3]},
                  {handle_1, [message_4, message_5]}
                ]}
    end
  end

  describe ".group_messages_by_handle/1" do
    test "with empty messages" do
      messages = []
      assert ChatThreads.group_messages_by_handle(messages) == []
    end

    test "with valid messages" do
      unix_1 = 100_000_000_000_000
      handle_1 = build(:handle)
      handle_2 = build(:handle)

      message_1 = build(:message, handle: handle_1, date: unix_1 + 1)
      message_2 = build(:message, handle: handle_1, date: unix_1 + 2)
      message_3 = build(:message, handle: handle_2, date: unix_1 + 3)
      message_4 = build(:message, handle: handle_1, date: unix_1 + 4)
      message_5 = build(:message, handle: handle_1, date: unix_1 + 5)

      messages = [
        message_1,
        message_2,
        message_3,
        message_4,
        message_5
      ]

      assert ChatThreads.group_messages_by_handle(messages) == [
               {handle_1, [message_1, message_2]},
               {handle_2, [message_3]},
               {handle_1, [message_4, message_5]}
             ]
    end
  end
end
