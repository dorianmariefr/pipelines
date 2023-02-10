class Source
  class HackerNews
    class News
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
            summary: title,
            id: external_id,
            title: title,
            host: host,
            domain: domain,
            protocol: protocol,
            domain_with_path: domain_with_path,
            domain_url: domain_url,
            path: path,
            href: href,
            url: url,
            keywords: keywords,
            score: score,
            age: age,
            comments: comments,
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
        rescue URI::InvalidURIError
          URI.parse(CGI.escape(url))
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
          subtext.at_css(".score")&.text.to_i
        end

        def age
          subtext.at_css(".age").attribute("title")
        end

        def comments
          subtext.at_css(".subline > a:last-child")&.text&.to_i
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
    end
  end
end
