class ChatWorkServices::AnalyzeSearchWordsServices
  attr_accessor :message, :formated_keywords

  def initialize message
    @message = message&.downcase
  end

  def analyze
    reformat_keywords
    analyze_formated_keywords
  end

  private

  def analyze_formated_keywords
    keywords = formated_keywords & CommonKeyWordApiSearch::ANALYZE_KEY_WORDS
    return :not_found if keywords.blank?

    keywords.map do |word|
      idx = formated_keywords.index(word)
      {
        key: word,
        idx: idx,
        str: formated_keywords.slice(idx, CommonKeyWordApiSearch::MATCH_WORD_LENGTH).join(" ")
      }
    end.sort{|kw| kw[:idx]}
  end

  def reformat_keywords
    @formated_keywords = message.split("\n")[1].gsub(/[\,\:\;]/, "").split(" ")
      .slice(0, CommonKeyWordApiSearch::FORMATED_LENGTH)
  end
end
