require 'net/http'

class OpenMovieApi
  EN_GET_MOVIE_QUERY = "https://www.imdb.com/what-to-watch/fan-favorites/?ref_=hm_fanfav_sm"
  EN_FAVOURITE_QUERY = "https://graphql.imdb.com"
  EN_POST_QUERY_PARAMS = "query FanFavorites($first: Int!, $after: ID) {\n  fanPicksTitles(first: $first, after: $after) {\n    edges {\n      node {\n        ...TitleCardWithTrailer\n        __typename\n      }\n      __typename\n    }\n    __typename\n  }\n}\n\nfragment TitleCardWithTrailer on Title {\n  ...TitleCard\n  latestTrailer {\n    id\n    __typename\n  }\n}\n\nfragment TitleCard on Title {\n  id\n  titleText {\n    text\n    __typename\n  }\n  primaryImage {\n    id\n    width\n    height\n    url\n    __typename\n  }\n  releaseYear {\n    year\n    __typename\n  }\n  ratingsSummary {\n    aggregateRating\n    voteCount\n    __typename\n  }\n  primaryWatchOption {\n    additionalWatchOptionsCount\n    __typename\n  }\n  runtime {\n    seconds\n    __typename\n  }\n  certificate {\n    rating\n    __typename\n  }\n}\n"
  EN_DEFAULT_PARAMS = {
    "query": EN_POST_QUERY_PARAMS,
    "operationName": "FanFavorites",
    "variables": {"first":50}
  }

  attr_reader :type
  attr_accessor :uri, :m_cookies, :req

  def initialize options={}
    @type = options[:type]
  end

  def favourite_movies
    en_build_cookies
  end

  private

  def en_build_cookies
    if m_cookies.blank?
      build_uri
      build_get_req
      call_api
    end
    build_uri true
    build_post_req
    call_api false
  end

  def build_uri is_query_data=false
    url = is_query_data ? EN_FAVOURITE_QUERY : EN_GET_MOVIE_QUERY
    @uri = URI(url)
  end

  def build_get_req
    @req = Net::HTTP::Get.new(uri)
    @req['user-agent'] = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.125 Safari/537.36"
    @req['accept'] = "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9"
    @req['upgrade-insecure-requests'] = "1"
    @req['cache-control'] = "no-cache"
  end

  def build_post_req
    @req = Net::HTTP::Post.new(uri, initheader = {'Content-Type' =>'application/json'})
    @req['cookie'] = m_cookies
    @req['accept'] = "*/*"
    @req['referer'] = "https://www.imdb.com/what-to-watch/fan-favorites/?ref_=hm_fanfav_sm"
    @req.body = build_query_params
  end

  def build_query_params
    EN_DEFAULT_PARAMS.to_json
  end

  def handle_cookies
    m_cookies.map do |cookie|
      cookie.sub("Domain=.imdb.com", "Domain=graphql.imdb.com")
    end
  end

  def default_option
    "&lang=#{DEFAULT_LANG}&units=#{DEFAULT_UNIT}"
  end

  def call_api is_get_cookies=true
    res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => true) do |http|
      @req['content-type'] = "application/json"
      http.request(req)
    end

    case res
    when Net::HTTPSuccess, Net::HTTPRedirection
      @m_cookies = res.header.get_fields('set-cookie') if is_get_cookies
      JSON.parse(res.body) if req.method.to_sym === :POST
    else
      p "something wrong"
      nil
    end
  end
end
