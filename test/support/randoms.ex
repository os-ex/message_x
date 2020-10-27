defmodule MessageX.Support.Randoms do
  @moduledoc """
  Generates randomized fields.
  """

  # credo:disable-for-this-file

  alias DarkMatter.Decimals

  alias Faker.Address, as: FakerAddress
  # alias Faker.Address.En, as: FakerAddressEn
  alias Faker.Date, as: FakerDate
  alias Faker.DateTime, as: FakerDateTime
  alias Faker.File, as: FakerFile
  # alias Faker.Internet, as: FakerInternet
  alias Faker.Internet.UserAgent, as: FakerUserAgent
  alias Faker.Lorem, as: FakerLorem
  alias Faker.Person.En, as: FakerPerson
  # alias Faker.Phone.EnUs, as: FakerPhone
  alias Faker.String, as: FakerString

  require Logger

  defdelegate pick(enum), to: Faker.Util
  defdelegate digit(), to: Faker.Util

  @doc """
  Choses a random entry from `enum`.
  """
  def random(:xml), do: "<xml></xml>"
  def random(:map), do: %{}
  def random(:array), do: []
  def random(:guid), do: Faker.UUID.v4()
  def random(:uuid), do: Faker.UUID.v4()
  def random(:stream_uuid), do: random(:uuid)
  def random(:primary_key), do: random(:pos_integer)
  def random(:binary), do: Faker.random_bytes(128)
  def random(:float), do: Faker.random_uniform()
  def random(:integer), do: Faker.random_between(-1_000_000, 1_000_000)
  def random(:pos_integer), do: Faker.random_between(1, 1_000_000)
  def random(:decimal), do: random_decimal()
  def random(:text), do: FakerLorem.paragraph()
  def random(:string), do: Faker.String.base64()
  def random(:boolean), do: pick([true, false])
  def random(:date), do: FakerDate.backward(100)
  def random(:datetime), do: FakerDateTime.backward(100)
  def random(:naive_datetime), do: random(:datetime)
  def random(:naive_datetime_usec), do: random(:datetime)
  def random(:utc_datetime), do: random(:datetime)
  def random(:utc_datetime_usec), do: random(:datetime)
  def random(:time), do: Time.utc_now()
  def random(:time_usec), do: random(:time)
  def random({:array, type}), do: [random(type)]

  # iOS
  # def random(:boolean_int), do: pick([0, 1])
  def random(:boolean_int), do: pick([true, false])

  # Common
  def random(:short_id), do: Faker.UUID.v4() |> String.replace("-", "")

  # Users
  def random(:first_name), do: FakerPerson.first_name()
  def random(:middle_name), do: FakerPerson.first_name()
  def random(:last_name), do: FakerPerson.last_name()
  def random(:full_name), do: FakerPerson.name()

  # Internet
  def random(:url), do: FakerInternet.url()
  def random(:email), do: FakerInternet.email()

  def random(:domain),
    do: FakerInternet.domain_word() <> "-#{pick(0..999)}-" <> FakerInternet.domain_name()

  def random(:username), do: FakerInternet.user_name() <> "#{pick(0..999)}"
  def random(:user_agent), do: FakerUserAgent.user_agent()
  def random(:avatar_url), do: FakerInternet.image_url()
  def random(:identicon_url), do: FakerInternet.image_url()
  def random(:ip_address), do: FakerInternet.ip_v4_address()
  def random(:ip_address_v4), do: FakerInternet.ip_v4_address()
  def random(:ip_address_v6), do: FakerInternet.ip_v6_address()
  def random(:mac_address), do: FakerInternet.mac_address()
  def random(:filename), do: FakerFile.file_name()
  def random(:mime_type), do: FakerFile.mime_type()
  def random(:phone_number), do: random(:compressed_us_phone_number)
  def random(:us_phone_number), do: random(:compressed_us_phone_number)

  # Geolocation
  def random(:latitude), do: FakerAddress.latitude()
  def random(:longitude), do: FakerAddress.longitude()

  # def random(:email), do: random(:email, :string)
  # def random(:avatar_url), do: random(:avatar_url, :string)
  # def random(:identicon_url), do: random(:identicon_url, :string)
  # def random(:phone_number), do: random(:phone_number, :string)

  def random(_), do: nil

  # UUID
  # def random(:short_id, :string), do: Faker.UUID.v4() |> String.replace("-", "")

  # Documents
  def random(:image_b64, :string), do: FakerString.base64()

  # Default Cases
  def random(field, type) do
    case {random(field), random(type)} do
      {nil, nil} ->
        Logger.warn("""

        ------------------------------------------------
        `MessageX.Randoms.random/2` was unable to generate a case for:

          iex> Randoms.random(#{inspect(field)}, #{inspect(type)})

        ------------------------------------------------
        """)

        nil

      {random_field, random_type} ->
        random_field || random_type
    end
  end

  def random(_module, field, type), do: random(field, type)

  @doc """
  Builds a random Decimal` between `min` and `max`.
  """
  def random_decimal, do: random_decimal(-1_000_000..1_000_000)

  def random_decimal(min..max) do
    min..max
    |> pick()
    |> Decimals.cast_decimal!(:normal)
  end

  @doc """
  Choses a random entry from either `enum` or between `first` and `last`.
  """
  def pick_random(enum) when is_list(enum), do: pick(enum)
  def pick_random(first..last), do: pick(first..last)
end
