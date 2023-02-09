class Source
  class Twitter
    class Search
      EXPIRES_IN = 1.minute
      TWEET_MODE = :extended

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
          {name: :query, type: :string, required: true, fakes: fake_queries},
          {
            name: :result_type,
            type: :list,
            default: RESULT_TYPE_DEFAULT,
            options: RESULT_TYPE_OPTIONS
          },
          {
            name: :limit,
            type: :list,
            default: user&.pro? ? LIMIT_DEFAULT_PRO : LIMIT_DEFAULT_FREE,
            options: user&.pro? ? LIMIT_OPTIONS_PRO : LIMIT_OPTIONS_FREE
          }
        ]
      end

      def self.keys
        %w[
          summary
          id
          url
          text
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
        return [] if query.blank?

        Rails
          .cache
          .fetch(
            [self.class.name, query, result_type, limit],
            expires_in: EXPIRES_IN
          ) do
            client
              .search(query, result_type: result_type, tweet_mode: TWEET_MODE)
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
