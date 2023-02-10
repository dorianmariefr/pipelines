class Source
  class Twitter
    class Home
      class AccountNotAuthorized < Source::Error
        def message
          I18n.t("errors.account_not_authorized")
        end
      end

      class AccountNotFound < Source::Error
        def message
          I18n.t("errors.account_not_found")
        end
      end

      class Tweet < Source::Twitter::Search::Tweet
      end

      EXPIRES_IN = 1.minute
      TWEET_MODE = :extended

      def initialize(source)
        @source = source
      end

      def self.default_twitter_identifier_for(user)
        return unless user
        account =
          user.accounts.twitter.authorized.first || user.accounts.twitter.first
        account&.external_id
      end

      def self.fake_twitter_identifiers
        (1..3).map { |domain| "@#{Faker::Internet.username}" }
      end

      def self.parameters_for(user)
        [
          {
            name: :identifier,
            type: :twitter_identifier,
            required: true,
            default: default_twitter_identifier_for(user),
            fakes: fake_twitter_identifiers,
            scope: :twitter
          }
        ]
      end

      def self.keys
        Source::Twitter::Search.keys
      end

      def fetch
        Rails
          .cache
          .fetch([self.class.name, identifier], expires_in: EXPIRES_IN) do
            client
              .home_timeline(tweet_mode: TWEET_MODE)
              .map { |tweet| Tweet.new(tweet) }
          end
      end

      private

      attr_reader :source

      delegate :user, to: :source
      delegate :identifier, to: :params
      delegate :access_token, :access_token_secret, to: :account

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

      def bearer_token
        Rails.application.credentials.twitter.bearer_token
      end

      def account
        user.accounts.twitter.find_by(external_id: identifier)
      end

      def check_if_authorized_account!
        if account
          if account.authorized?
            nil
          else
            raise AccountNotAuthorized
          end
        else
          raise AccountNotFound
        end
      end
    end
  end
end
