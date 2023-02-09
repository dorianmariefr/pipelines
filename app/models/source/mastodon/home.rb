class Source
  class Mastodon
    class Home
      class AccountNotAuthorized < StandardError
        def message
          I18n.t("errors.account_not_authorized")
        end
      end

      class AccountNotFound < StandardError
        def message
          I18n.t("errors.account_not_found")
        end
      end

      def initialize(source)
        @source = source
      end

      def self.mastodon_domains
        File.read(
          Rails.root.join("lib", "data", "mastodon", "domains.txt")
        ).split
      end

      def self.mastodon_addresses
        mastodon_domains.map do |domain|
          "@#{Faker::Internet.username}@#{domain}"
        end
      end

      def self.fake_mastodon_addresses
        mastodon_addresses.sample(3)
      end

      def self.default_mastodon_identifier_for(user)
        return unless user
        account =
          user.accounts.mastodon.authorized.first ||
          user.accounts.mastodon.first
        account&.external_id
      end

      def self.parameters_for(user)
        [
          {
            name: :identifier,
            type: :mastodon_identifier,
            default: default_mastodon_identifier_for(user),
            required: true,
            scope: :mastodon
          }
        ]
      end

      def self.keys
        []
      end

      def fetch
        check_if_authorized_account!

        uri = URI.parse("https://#{domain}/api/v1/timelines/home")
        request = Net::HTTP::Get.new(uri)
        request["Authorization"] = "Bearer #{access_token}"

        response =
          Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
            http.request(request)
          end

        JSON.parse(response.body).map { |status| Status.new(status) }
      end

      private

      attr_reader :source

      delegate :identifier, to: :params
      delegate :user, to: :source
      delegate :access_token, :domain, to: :account

      def params
        OpenStruct.new(source.params)
      end

      def account
        user.accounts.mastodon.find_by(external_id: identifier)
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
