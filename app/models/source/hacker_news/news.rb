class Source
  class HackerNews
    class News
      BASE_URL = "https://news.ycombinator.com"
      TARGET_URL = BASE_URL

      def initialize(source)
        @source = source
      end

      def fetch
        response =
          Rails
            .cache
            .fetch(TARGET_URL, expires_in: 1.minute) do
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
