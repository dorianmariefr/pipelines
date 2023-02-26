class Source
  class Twitter
    class SearchScraper
      class Tweet
        BASE_URL = "https://twitter.com"

        def initialize(tweet, users:)
          @tweet = tweet
          @users = users
        end

        def external_id
          tweet["id"].to_s
        end

        def extras
          tweet.merge(
            user: user,
            summary: tweet["full_text"],
            url: url,
            in_reply_to: in_reply_to
          )
        end

        def to_s
          extras.to_s
        end

        def inspect
          extras.inspect
        end

        private

        attr_reader :tweet, :users

        def user
          users[tweet["user_id"].to_s]
        end

        def in_reply_to
          return unless tweet["in_reply_to_status_id"]
          reply =
            client.status(tweet["in_reply_to_status_id"], tweet_mode: :extended)
          Source::Twitter::Search::Tweet.new(reply).extras
        rescue ::Twitter::Error::Forbidden
          nil
        end

        def url
          "#{BASE_URL}/#{user["screen_name"]}/status/#{tweet["id"]}"
        end

        def client
          ::Twitter::REST::Client.new do |config|
            config.consumer_key = api_key
            config.consumer_secret = api_key_secret
            config.bearer_token = bearer_token
          end
        end

        def api_key
          Rails.application.credentials.twitter.api_key
        end

        def api_key_secret
          Rails.application.credentials.twitter.api_key_secret
        end

        def bearer_token
          Rails.application.credentials.twitter.bearer_token
        end
      end
    end
  end
end
