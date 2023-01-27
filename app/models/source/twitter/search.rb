class Source
  class Twitter
    class Search
      EXPIRES_IN = 1.minute

      RESULT_TYPES =
        %w[mixed recent popular].map do |result_type|
          [result_type, result_type]
        end

      LIMIT_FREE = 5
      LIMITS = [1, 5, 10, 20]

      LIMITS_FREE =
        LIMITS.map do |limit|
          [
            limit.to_s,
            (
              if limit > LIMIT_FREE
                I18n.t("parameters.limit_disabled", limit: limit)
              else
                limit.to_s
              end
            ),
            limit > LIMIT_FREE
          ]
        end

      LIMITS_PRO = LIMITS.map { |limit| [limit.to_s, limit.to_s] }

      def initialize(source)
        @source = source
      end

      def self.keys
        %w[
          text
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

      def self.as_json(...)
        {
          keys: keys,
          parameters: {
            result_type: {
              default: "recent",
              translate: false,
              kind: :select,
              options: RESULT_TYPES
            },
            query: {
              default: "from:dorianmariefr",
              kind: :string
            },
            limit: {
              default: Current.pro? ? LIMITS.last : LIMITS.first,
              translate: false,
              kind: :select,
              options: Current.pro? ? LIMITS_PRO : LIMITS_FREE
            }
          }
        }.as_json(...)
      end

      def as_json(...)
        self.class.as_json(...)
      end

      def fetch
        return [] if query.blank?

        Rails
          .cache
          .fetch(
            [self.class.name, query, result_type, limit],
            expires_in: EXPIRES_IN
          ) do
            client
              .search(query, result_type: result_type)
              .take(limit.to_i)
              .map { |tweet| Tweet.new(tweet) }
          end
      end

      private

      attr_reader :source

      delegate :query, :result_type, :limit, to: :params

      def params
        OpenStruct.new(source.params)
      end

      def client
        ::Twitter::REST::Client.new do |config|
          config.consumer_key = api_key
          config.consumer_secret = api_key_secret
          config.bearer_token = bearer_token
          config.access_token = access_token
          config.access_token_secret = access_token_secret
        end
      end

      def api_key
        Rails.application.credentials.twitter.api_key
      end

      def api_key_secret
        Rails.application.credentials.twitter.api_key_secret
      end

      def access_token
        Rails.application.credentials.twitter.access_token
      end

      def access_token_secret
        Rails.application.credentials.twitter.access_token_secret
      end

      def bearer_token
        Rails.application.credentials.twitter.bearer_token
      end
    end
  end
end
