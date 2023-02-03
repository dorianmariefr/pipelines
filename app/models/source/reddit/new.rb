class Source
  class Reddit
    class New
      BASE_URL = "https://api.reddit.com"
      EXPIRES_IN = 1.minute
      USER_AGENT = "pipelines.plumbing"

      def initialize(source)
        @source = source
      end

      def self.subreddits
        File.read(Rails.root.join("lib", "data", "subreddits.txt")).split
      end

      def self.fake_subreddits
        subreddits.sample(3)
      end

      def self.parameters_for(_user)
        [{ name: :subreddit, type: :string, fakes: fake_subreddits }]
      end

      def self.keys
        %w[
          summary
          title
          kind
          subreddit
          subreddit_type
          ups
          downs
          score
          thumbnail
          selftext_html
          views
          url
          id
        ]
      end

      def fetch
        url =
          if subreddit.present?
            "#{BASE_URL}/r/#{subreddit}/new"
          else
            "#{BASE_URL}/new"
          end

        response =
          Rails
            .cache
            .fetch(
              [self.class.name, url, USER_AGENT],
              expires_in: EXPIRES_IN
            ) { Net::HTTP.get(URI(url), { "User-Agent": USER_AGENT }) }

        json = JSON.parse(response, object_class: OpenStruct)

        if json.error
          raise "#{json.error}: #{json.message}"
        else
          json.data.children.map { |listing| Listing.new(listing) }
        end
      end

      private

      attr_reader :source

      delegate :subreddit, to: :params

      def params
        OpenStruct.new(source.params)
      end
    end
  end
end
