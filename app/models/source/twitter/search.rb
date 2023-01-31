class Source
  class Twitter
    class Search
      EXPIRES_IN = 1.minute

      def initialize(source)
        @source = source
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
