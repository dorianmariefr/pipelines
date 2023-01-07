class Source
  class HackerNews
    class News
      BASE_URL = "https://news.ycombinator.com"

      class Item
        def initialize(node)
          @node = node
        end

        def subject
          title
        end

        def body
          "#{url}\n\n#{item_url}"
        end

        def external_id
          node["id"]
        end

        private

        attr_reader :node

        def title
          node.at_css(".titleline a").text
        end

        def url
          node.at_css(".titleline a").attribute("href")
        end

        def item_url
          "#{BASE_URL}/item?id=#{external_id}"
        end
      end

      def self.fetch
        response = Net::HTTP.get(URI(BASE_URL))
        page = Nokogiri.HTML(response)
        page.css(".athing").map { |item| Item.new(item) }
      end
    end
  end
end
