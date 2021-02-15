class FbsServices::AnalyzeSearchWordsService
  attr_accessor :message, :formated_keywords

  CMD_KEYWORDS_STR = CommonKeyWordApiSearch::ANALYZE_CMD_KEY_WORDS.join("|")
  CMD_REGEX = /^\#(#{CMD_KEYWORDS_STR})/

  def initialize message
    @message = message.squish&.downcase
  end

  def analyze
    return :not_found if message.blank?
    formated_cmd_message if is_cmd_keyword?
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
    @formated_keywords = message.gsub(/[\,\:\;]/, "").squish.split(" ")
      .slice(0, CommonKeyWordApiSearch::FORMATED_LENGTH)
  end

  def is_cmd_keyword?
    message.match?(CMD_REGEX)
  end

  def formated_cmd_message
    @message = message.sub(CMD_REGEX, "").squish
  end
end
