defmodule MessageX.NLP do
  @moduledoc """
  NLP tools
  """

  @known_invalid_phrases [
    "",
    "!!!"
  ]

  @doc """
  Returns a sentiment value for the given text

  ## Examples

      iex> sentiment(["I ❤️ NLP", "NLP is really awesome"])
      [3, 5]

      iex> sentiment("I love NLP")
      3
  """
  @spec sentiment(any()) :: integer() | [integer()] | :invalid | :error
  def sentiment(phrase) when phrase in @known_invalid_phrases do
    :invalid
  end

  def sentiment(phrase) when is_binary(phrase) or is_list(phrase) do
    Veritaserum.analyze(phrase)
  rescue
    _error -> :error
  end

  def sentiment(_) do
    :error
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
  def sentiment_with_marks(phrase) when is_binary(phrase) do
    Veritaserum.analyze(phrase, return: :score_and_marks)
  end
end
