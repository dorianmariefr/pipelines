class Source
  class Reddit
    class New
      BASE_URL = "https://api.reddit.com"
      EXPIRES_IN = 1.minute
      USER_AGENT = "pipelines.plumbing"

      def initialize(source)
        @source = source
      end

      def self.keys
        %w[
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

      def self.as_json(...)
        {
          keys: keys,
          parameters: {
            subreddit: {
              default: "",
              kind: :string
            }
          }
        }.as_json(...)
      end

      def self.email_subject_default
        "{title}"
      end

      def self.email_body_default
        <<~TEMPLATE
          {url}

          {pipeline.url}
        TEMPLATE
      end

      def self.email_digest_subject_default
        "{items.first.title}"
      end

      def self.email_digest_body_default
        <<~TEMPLATE
          {items.each do |item|
            puts(item.title)
            puts
            puts(item.url)
            puts
          end
          nothing}

          {pipeline.url}
        TEMPLATE
      end

      def as_json(...)
        self.class.as_json(...)
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
