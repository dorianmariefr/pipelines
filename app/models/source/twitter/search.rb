class Source
  class Twitter
    class Search
      LIMIT = 5
      EXPIRES_IN = 1.minute

      def initialize(source)
        @source = source
      end

      def fetch
        Rails
          .cache
          .fetch(
            [self.class.name, query, result_type],
            expires_in: EXPIRES_IN
          ) do
            client
              .search(query, result_type: result_type)
              .take(LIMIT)
              .map { |tweet| Tweet.new(tweet) }
          end
      end

      private

      attr_reader :source

      delegate :query, :result_type, to: :params

      def params
        Struct.new(*source.params.deep_symbolize_keys.keys).new(
          *source.params.values
        )
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
