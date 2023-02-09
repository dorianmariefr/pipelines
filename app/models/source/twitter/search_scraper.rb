class Source
  class Twitter
    class SearchScraper
      SEARCH_URL = "https://twitter.com/search"
      SEARCH_EXPIRES_IN = 1.hour
      EXPIRES_IN = 1.minute
      COOKIE_SPLIT_FIRST_PART = 'document.cookie = decodeURIComponent("gt='
      COOKIE_SPLIT_SECOND_PART = ";"
      SCRIPT_REGEXP =
        %r{https://abs\.twimg\.com/responsive-web/[^/]+/main\.[^.]+\.js}
      TWEET_MODE = :extended
      SCRIPT_EXPIRES_IN = 1.day
      AUTHORIZATION_BEARER_REGEXP = /"(AAAAAAAAAAAAAAA[a-zA-Z0-9%]+)"/
      SEARCH_API_URL = "https://api.twitter.com/2/search/adaptive.json"
      USER_AGENT =
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36"

      RECENT = "recent"
      RESULT_TYPE_DEFAULT = "recent"
      RESULT_TYPE_OPTIONS =
        %w[recent popular mixed].map do |result_type|
          [I18n.t("parameters.result_types.#{result_type}"), result_type]
        end
      LIMIT_DEFAULT_FREE = 5
      LIMIT_DEFAULT_PRO = 20

      LIMIT_OPTIONS_FREE = [["5", "5", false], ["20 (Pro)", "20", true]]
      LIMIT_OPTIONS_PRO = [%w[5 5], ["20 (Pro)", "20"]]

      def initialize(source)
        @source = source
      end

      def self.fake_queries
        (1..3).map { Faker::Hobby.activity }
      end

      def self.parameters_for(user)
        [
          {
            name: :query,
            type: :string,
            required: true,
            fakes: fake_queries,
            scope: :twitter
          },
          {
            name: :result_type,
            type: :list,
            default: RESULT_TYPE_DEFAULT,
            options: RESULT_TYPE_OPTIONS,
            scope: :twitter
          },
          {
            name: :limit,
            type: :list,
            default: user&.pro? ? LIMIT_DEFAULT_PRO : LIMIT_DEFAULT_FREE,
            options: user&.pro? ? LIMIT_OPTIONS_PRO : LIMIT_OPTIONS_FREE,
            scope: :twitter
          }
        ]
      end

      def self.keys
        %w[
          text
          summary
          id
          url
          created_at
          quote?
          retweets
          likes
          lang
          user_id
          user_name
          user_handle
          user_location
          user_description
          user_url
          user_profile_url
          user_protected
          user_followers
          user_friends
          user_listed
          user_created_at
          user_likes
          user_verified
          user_tweets
          user_background_image_url
          user_image_url
        ]
      end

      def fetch
        search_page =
          Rails
            .cache
            .fetch(
              [self.class.name, SEARCH_URL],
              expires_in: SEARCH_EXPIRES_IN
            ) do
              uri = URI(SEARCH_URL)
              request = Net::HTTP::Get.new(uri)
              request["User-Agent"] = USER_AGENT
              response =
                Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
                  http.request(request)
                end
              response.body
            end

        script_url = search_page.scan(SCRIPT_REGEXP).first

        script_page =
          Rails
            .cache
            .fetch(
              [self.class.name, script_url],
              expires_in: SCRIPT_EXPIRES_IN
            ) { Net::HTTP.get(URI(script_url)) }

        guest_token = search_page.split(COOKIE_SPLIT_FIRST_PART).last
        guest_token = guest_token.split(COOKIE_SPLIT_SECOND_PART).first
        authorization_bearer =
          script_page.scan(AUTHORIZATION_BEARER_REGEXP).first.last

        query_params = {
          q: query,
          tweet_mode: TWEET_MODE,
          tweet_search_mode: (result_type == RECENT) ? "live" : nil
        }.compact

        url = "#{SEARCH_API_URL}?#{query_params.to_query}"
        uri = URI(url)

        json =
          Rails
            .cache
            .fetch(
              [self.class.name, url, guest_token, authorization_bearer],
              expires_in: EXPIRES_IN
            ) do
              request = Net::HTTP::Get.new(uri)
              request["X-Guest-Token"] = guest_token
              request["Authorization"] = "Bearer #{authorization_bearer}"
              request["User-Agent"] = USER_AGENT
              response =
                Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
                  http.request(request)
                end
              JSON.parse(response.body, object_class: OpenStruct)
            end

        json.globalObjects.tweets.to_h.values.map do |tweet|
          Tweet.new(tweet, users: json.globalObjects.users)
        end
      end

      private

      attr_reader :source

      delegate :query, :result_type, :limit, to: :params

      def params
        OpenStruct.new(source.params)
      end
    end
  end
end
