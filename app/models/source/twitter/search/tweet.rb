class Source
  class Twitter
    class Search
      class Tweet
        BASE_URL = "https://twitter.com"

        def initialize(tweet, include_in_reply_to: true)
          @tweet = tweet
          @include_in_reply_to = include_in_reply_to
        end

        def external_id
          tweet.id.to_s
        end

        def extras
          tweet.as_json.merge(
            summary: tweet.text,
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

        attr_reader :tweet, :include_in_reply_to

        delegate :user, to: :tweet

        def url
          "#{BASE_URL}/#{user.screen_name}/status/#{tweet.id}"
        end

        def include_in_reply_to?
          !!include_in_reply_to
        end

        def in_reply_to
          return unless include_in_reply_to?
          return unless tweet.in_reply_to_status_id
          reply =
            client.status(tweet.in_reply_to_status_id, tweet_mode: :extended)
          Source::Twitter::Search::Tweet.new(
            reply,
            include_in_reply_to: false
          ).extras
        rescue ::Twitter::Error::Forbidden, ::Twitter::Error::NotFound
          nil
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
