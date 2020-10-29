defmodule MessageX.Chats.Attachment do
  @moduledoc """
  Ash resource for attachments.
  """

  use Ash.Resource, data_layer: AshPostgres.DataLayer

  alias MessageX.Types

  resource do
    base_filter(not: [is_nil: :filename])
  end

  postgres do
    table("attachment")
    repo(MessageX.Repo)
    # base_filter_sql("filename IS NOT NULL AND total_bytes > 0 AND hide_attachment = 0")
  end

  actions do
    read :read do
      primary?(true)
    end

    read :most_recent do
      pagination offset?: true, countable: true, required?: true
    end
  end

  @derive {Phoenix.Param, key: :rowid}
  @primary_key {:rowid, :integer, []}
  attributes do
    attribute :rowid, :integer do
      primary_key?(true)
    end

    attribute(:guid, :string) do
      description """
      UUID
      """
    end

    attribute(:filename, :string) do
      description """
      Path to file on local file system.
      """

      allow_nil? true
    end

    # Source File
    attribute(:uti, :string)
    attribute(:mime_type, :string, allow_nil?: true)
    attribute(:total_bytes, :integer, constraints: [min: 0])
    attribute(:transfer_name, :string)

    attribute(:hide_attachment, :integer) do
      description """
      Indicator if file is still available or hidden with a unicode seq.
      """

      constraints Types.constraints(:boolean_int)
    end

    attribute(:created_date, :integer) do
      description """
      Datetime received
      """

      constraints Types.constraints(:unix_timestamp)
    end

    attribute(:start_date, :integer) do
      description """
      Datetime opened? -- sometimes this is just 0
      """

      constraints Types.constraints(:unix_timestamp)
    end
  end
end
