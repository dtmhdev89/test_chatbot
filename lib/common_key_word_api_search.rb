module CommonKeyWordApiSearch
  extend ActiveSupport::Concern

  MATCH_WORD_LENGTH = 2
  FORMATED_LENGTH = 10

  ANALYZE_HELLO_KEY_WORDS = ["chào", "hello", "hi"].freeze
  ANALYZE_MAJOR_KEY_WORDS = ["phim", "thời"].freeze
  ANALYZE_WEATHER_KEY_WORDS = ["thời tiết"].freeze
  ANALYZE_MOVIE_KEY_WORDS = ["phim", "phim hay", "phim yêu", "phim mới"].freeze

  ANALYZE_KEY_WORDS = ANALYZE_HELLO_KEY_WORDS + ANALYZE_MAJOR_KEY_WORDS

  DEFAULT_RESULTS = {
    not_found: "Hỏi khó quá, không tìm được bạn ơi!"
  }

  MESSAGE_SETTINGS = {
    api_hello: :action_hello,
    api_major: :action_major
  }

  class CommonKeyWordApiSearch::Messages

    def action_hello key_word
      :hello
    end

    def action_major key_word
      return :weather if key_word.in?(ANALYZE_WEATHER_KEY_WORDS)
      return :movie if key_word.in?(ANALYZE_MOVIE_KEY_WORDS)
    end

    ANALYZE_HELLO_KEY_WORDS.each do |key|
      alias_method key, :action_hello
    end

    ANALYZE_MAJOR_KEY_WORDS.each do |key|
      alias_method key, :action_major
    end
  end
end
