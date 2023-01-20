class Source
  class Twitter
    class Search
      EXPIRES_IN = 1.minute

      def initialize(source)
        @source = source
      end

      def self.as_json
        {
          parameters: {
            result_type: {
              default: "recent",
              translate: false,
              kind: :select,
              options: Parameter::RESULT_TYPES
            },
            query: {
              default: "from:dorianmariefr",
              kind: :string
            },
            limit: {
              default:
                Current.pro? ? Parameter::LIMITS.last : Parameter::LIMITS.first,
              translate: false,
              kind: :select,
              options:
                Current.pro? ? Parameter::LIMITS_PRO : Parameter::LIMITS_FREE
            }
          }
        }
      end

      def self.email_subject_default
        "{text}"
      end

      def self.email_body_default
        <<~TEMPLATE
          {url}

          {user_url}

          {pipeline.url}
        TEMPLATE
      end

      def self.email_digest_subject_default
        "{items.first.text}"
      end

      def self.email_digest_body_default
        <<~TEMPLATE
          {items.each do |item|
            puts(item.text)
            puts
            puts(item.url)
            puts
          end
          nothing}

          {pipeline.url}
        TEMPLATE
      end

      def as_json
        self.class.as_json
      end

      def fetch
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
