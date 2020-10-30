defmodule MessageX.NLP do
  @moduledoc """
  NLP tools
  """

  @doc """
  Returns a sentiment value for the given text

  ## Examples

      iex> sentiment(["I ❤️ NLP", "NLP is really awesome"])
      [3, 5]

      iex> sentiment("I love NLP")
      3
  """
  @spec sentiment(String.t()) :: integer()
  def sentiment(binary) when is_binary(binary) do
    Veritaserum.analyze(binary)
  end

  @spec sentiment([String.t()]) :: [integer()]
  def sentiment(list) when is_list(list) do
    Veritaserum.analyze(list)
  end

  @doc """
  Returns a sentiment value for the given text

  ## Examples

      iex> sentiment_with_marks("I love NLP")
      {3, [{:neutral, 0, "i"}, {:word, 3, "love"}, {:neutral, 0, "nlp"}]}

      iex> sentiment_with_marks("I ❤️ NLP")
      {3, [{:neutral, 0, "i"}, {:emoticon, 3, "❤️"}, {:neutral, 0, "nlp"}]}
  """
  @spec sentiment_with_marks(String.t()) :: {number(), [{atom(), number(), String.t()}]}
  def sentiment_with_marks(binary) when is_binary(binary) do
    Veritaserum.analyze(binary, return: :score_and_marks)
  end
end
