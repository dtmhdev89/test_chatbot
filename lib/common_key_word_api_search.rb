module CommonKeyWordApiSearch
  extend ActiveSupport::Concern

  MATCH_WORD_LENGTH = 2
  FORMATED_LENGTH = 10

  ANALYZE_HELLO_KEY_WORDS = ["chào", "hello", "hi"].freeze
  ANALYZE_MAJOR_KEY_WORDS = ["phim", "thời"].freeze
  ANALYZE_WEATHER_KEY_WORDS = ["thời tiết"].freeze

  ANALYZE_KEY_WORDS = ANALYZE_HELLO_KEY_WORDS + ANALYZE_MAJOR_KEY_WORDS

  DEFAULT_RESULTS = {
    not_found: "Hỏi khó quá, không tìm được bạn ơi!"
  }

  MESSAGE_SETTINGS = {
    api_hello: :message_hello,
    api_major: :message_major
  }

  class CommonKeyWordApiSearch::Messages

    def message_hello key_word
      "mesage hello"
    end

    def message_major key_word

    end

    ANALYZE_HELLO_KEY_WORDS.each do |key|
      alias_method key, :message_hello
    end

    ANALYZE_MAJOR_KEY_WORDS.each do |key|
      alias_method key, :message_major
    end
  end
  class Messages

    def message_hello key_word
      "mesage hello"
    end

    def message_major key_word

    end

    ANALYZE_HELLO_KEY_WORDS.each do |key|
      alias_method key, :message_hello
    end

    ANALYZE_MAJOR_KEY_WORDS.each do |key|
      alias_method key, :message_major
    end
  end
end
