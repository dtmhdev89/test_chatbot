module CommonKeyWordApiSearch
  extend ActiveSupport::Concern

  MATCH_WORD_LENGTH = 2
  FORMATED_LENGTH = 10

  ANALYZE_TALK_KEY_WORDS = ["chào", "hello", "hi"].freeze
  ANALYZE_MAJOR_KEY_WORDS = ["phim", "thời"].freeze
  ANALYZE_NOTIFICATION_KEY_WORDS = ["create notification", "update notification", "delete notification",
    "find notification"
  ]
  ANALYZE_CMD_KEY_WORDS = ["ask", "search"].freeze
  ANALYZE_KEY_WORDS = ANALYZE_TALK_KEY_WORDS + ANALYZE_MAJOR_KEY_WORDS

  ANALYZE_WEATHER_KEY_WORDS = ["thời tiết"].freeze
  ANALYZE_MOVIE_KEY_WORDS = ["phim gì", "phim hay", "phim yêu", "phim mới"].freeze


  DEFAULT_RESULTS = {
    not_found: "Hỏi khó quá, không tìm được bạn ơi!"
  }

  MESSAGE_SETTINGS = {
    api_hello: :action_hello,
    api_major: :action_major
  }

  class Messages

    def action_hello key_word
      :hello
    end

    def action_major key_word
      return :weather if key_word.in?(ANALYZE_WEATHER_KEY_WORDS)
      return :movie if key_word.in?(ANALYZE_MOVIE_KEY_WORDS)
    end

    def action_notification key_word
      :notification
    end

    ANALYZE_TALK_KEY_WORDS.each do |key|
      alias_method key, :action_hello
    end

    ANALYZE_MAJOR_KEY_WORDS.each do |key|
      alias_method key, :action_major
    end

    alias_method :notification, :action_notification
  end
end
