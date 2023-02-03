class Source
  class HackerNews
    class Newest < News
      TARGET_URL = "#{BASE_URL}/newest"

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
    end
  end
end
