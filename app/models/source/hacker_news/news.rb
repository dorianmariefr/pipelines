class Source
  class HackerNews
    class News
      BASE_URL = "https://news.ycombinator.com"
      TARGET_URL = BASE_URL
      EXPIRES_IN = 1.minute

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
