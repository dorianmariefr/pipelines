class Source
  class HackerNews
    class Newest
      BASE_URL = "https://news.ycombinator.com"

      class Item
        def initialize(athing, subtext)
          @athing = athing
          @subtext = subtext
        end

        def external_id
          athing["id"]
        end

        def extras
          {
            id: external_id,
            title: title,
            protocol: protocol,
            host: host,
            domain: domain,
            domain_with_path: domain_with_path,
            domain_url: domain_url,
            path: path,
            href: href,
            url: url,
            keywords: keywords,
            score: score,
            comments_count: comments_count,
            comments_url: comments_url,
            user_id: user_id,
            user_url: user_url
          }
        end

        def to_s
          extras.to_s
        end

        def inspect
          extras.inspect
        end

        private

        attr_reader :athing, :subtext

        def title
          athing.at_css(".titleline a").text
        end

        def href
          athing.at_css(".titleline a").attribute("href").value
        end

        def url
          href.start_with?("item?id=") ? "#{BASE_URL}/#{href}" : href
        end

        def uri
          URI.parse(url)
        end

        def protocol
          uri.scheme
        end

        def host
          uri.host
        end

        def path
          uri.path
        end

        def domain
          PublicSuffix.parse(host).domain
        end

        def domain_with_path
          athing.at_css(".titleline .sitestr")&.text
        end

        def domain_url
          "#{BASE_URL}/#{athing.at_css(".titleline .sitebit")&.attribute("href")}"
        end

        def keywords
          title.split(/[^[[:word:]]]+/)
        end

        def item_url
          "#{BASE_URL}/item?id=#{external_id}"
        end

        def score
          subtext.at_css(".score")&.text&.to_i
        end

        def comments_count
          subtext.at_css(".subline a:last-child")&.text&.to_i
        end

        def comments_url
          item_url
        end

        def user_id
          subtext.at_css(".hnuser")&.text
        end

        def user_url
          "#{BASE_URL}/#{subtext.at_css(".hnuser")&.attribute("href")}"
        end
      end

      class Url
        attr_reader :text, :href

        def initialize(text:, href:)
          @text = text
          @href = href
        end
      end

      def initialize(item)
        @item = item
      end

      def self.fetch
        response = Net::HTTP.get(URI("#{BASE_URL}/newest"))
        page = Nokogiri.HTML(response)
        page
          .css(".athing")
          .map
          .with_index do |athing, index|
            subtext = page.css(".subtext")[index]
            Item.new(athing, subtext)
          end
      end

      def url
        extras.url
      end

      def urls
        [
          Url.new(text: domain, href: "#{protocol}://#{domain}"),
          (
            Url.new(text: host, href: "#{protocol}://#{host}") if domain != host
          ),
          (Url.new(text: user_id, href: user_url) if user_id && user_url),
          (
            if comments_count && comments_url
              Url.new(
                text:
                  I18n.t(
                    "sources.hacker_news.newest.comments",
                    count: comments_count
                  ),
                href: comments_url
              )
            end
          )
        ].compact
      end

      def email_subject
        title
      end

      def email_body
        "#{url}\n\n#{comments_url}"
      end

      def to_s
        title
      end

      private

      attr_reader :item

      def extras
        OpenStruct.new(item.extras)
      end

      def title
        extras.title
      end

      def domain
        extras.domain
      end

      def host
        extras.host
      end

      def protocol
        extras.protocol
      end

      def comments_url
        extras.comments_url
      end

      def comments_count
        extras.comments_count
      end

      def score
        extras.score
      end

      def user_id
        extras.user_id
      end

      def user_url
        extras.user_url
      end
    end
  end
end
