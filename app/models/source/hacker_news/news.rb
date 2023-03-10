class Source
  class HackerNews
    class News
      BASE_URL = "https://news.ycombinator.com"
      TARGET_URL = BASE_URL
      EXPIRES_IN = 1.minute

      def self.parameters_for(_user)
        []
      end

      def self.keys
        %w[
          summary
          id
          title
          host
          domain
          protocol
          domain_with_path
          domain_url
          path
          href
          url
          keywords
          score
          age
          comments_count
          comments_url
          user_id
          user_url
        ]
      end

      def initialize(source)
        @source = source
      end

      def fetch
        response =
          Rails
            .cache
            .fetch([self.class.name, TARGET_URL], expires_in: EXPIRES_IN) do
              Net::HTTP.get(URI(TARGET_URL))
            end
        page = Nokogiri.HTML(response)
        page
          .css(".athing")
          .map
          .with_index do |athing, index|
            subtext = page.css(".subtext")[index]
            Item.new(athing, subtext)
          end
      end

      private

      attr_reader :source
    end
  end
end
