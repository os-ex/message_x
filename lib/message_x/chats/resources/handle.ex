defmodule MessageX.Chats.Handle do
  @moduledoc """
  Ash resource for handles.
  """

  use Ash.Resource, data_layer: AshPostgres.DataLayer

  postgres do
    table("handle")
    repo(MessageX.Repo)
  end

  actions do
    read :read do
      primary?(true)
    end
  end

  validations do
    validate(one_of(:country, ["us", "US"]))
    validate(one_of(:service, ["SMS", "iMessage"]))
  end

  @derive {Phoenix.Param, key: :rowid}
  @primary_key {:rowid, :integer, []}
  attributes do
    attribute :rowid, :integer do
      primary_key?(true)
    end

    attribute(:id, :string) do
      description("""
      This is either an iMessage email address or phone number.

      If it's a phone number it will contain either an addtional `+`, `+1` when
      compared to the `uncanonicalized_id`.
      """)
    end

    attribute(:uncanonicalized_id, :string) do
      description("""
      This is either an iMessage email address or phone number with country code
      stripped
      """)
    end

    attribute(:country, :string)
    attribute(:service, :string)
  end

  def postgres_ddl do
    """
    create table handle
    (
      ROWID INTEGER
        primary key autoincrement
        unique,
      id TEXT not null,
      country TEXT,
      service TEXT not null,
      uncanonicalized_id TEXT,
      unique (id, service)
    );
    """
  end
end
