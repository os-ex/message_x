defmodule MessageX.NLP.Intent do
  @moduledoc """
  Intent Classification.
  """

  alias Penelope.NLP.IntentClassifier

  @pipeline %{
    tokenizer: [{:ptb_tokenizer, []}],
    classifier: [{:count_vectorizer, []}, {:linear_classifier, [probability?: true]}],
    recognizer: [{:crf_tagger, []}]
  }

  def predict(binary) when is_binary(binary) do
    x = [
      "you have four pears",
      "three hundred apples would be a lot"
    ]

    y = [
      {"intent_1", ["o", "o", "b_count", "b_fruit"]},
      {"intent_2", ["b_count", "i_count", "b_fruit", "o", "o", "o", "o"]}
    ]

    classifier = IntentClassifier.fit(%{}, x, y, @pipeline)

    {intents, params} =
      IntentClassifier.predict_intent(
        classifier,
        %{},
        "I have three bananas"
      )

    {intents, params}
  end
end
