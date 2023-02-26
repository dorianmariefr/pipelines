class Source
  class Twitter
    class Search
      class Tweet
        BASE_URL = "https://twitter.com"

        def initialize(tweet)
          @tweet = tweet
        end

        def external_id
          tweet.id.to_s
        end

        def extras
          tweet.as_json.merge(url: url)
        end

        def to_s
          extras.to_s
        end

        def inspect
          extras.inspect
        end

        private

        attr_reader :tweet

        delegate :user, to: :tweet

        def url
          "#{BASE_URL}/#{user.screen_name}/status/#{tweet.id}"
        end
      end
    end
  end
end
