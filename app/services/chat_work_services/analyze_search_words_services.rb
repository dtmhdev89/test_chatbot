class ChatWorkServices::AnalyzeSearchWordsServices
  attr_accessor :message, :message_arr, :formated_keywords, :cmd_line

  NOTI_KEYWORDS_STR = CommonKeyWordApiSearch::ANALYZE_NOTIFICATION_KEY_WORDS.join("|")
  NOTIFICATION_REGEX = /^\[code\](#{NOTI_KEYWORDS_STR})\[\/code\]$/
  REMOVE_LEADING_TRAILING_REGEX = /(\A[\s\n]+)|([\s\n]+\z)/

  def initialize message
    @message = message
    @message_arr = message&.gsub(REMOVE_LEADING_TRAILING_REGEX, "")&.split("\n")
    @message_arr&.shift()
  end

  def analyze
    return noti_analyzed_list if is_notification_keyword?
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
    @formated_keywords = message&.downcase.split("\n")[1].gsub(/[\,\:\;]/, "").split(" ")
      .slice(0, CommonKeyWordApiSearch::FORMATED_LENGTH)
  end

  def is_notification_keyword?
    @cmd_line = message_arr[0]&.downcase&.squish
    @cmd_line.match?(NOTIFICATION_REGEX)
  end

  def noti_analyzed_list
    [
      {
        key: :notification,
        str: cmd_line.gsub(/(\A\[code\]|\[\/code\]\z)/, "").split(" ").first,
        cmd_message: message_arr[1..-1]
      }
    ]
  end
end
