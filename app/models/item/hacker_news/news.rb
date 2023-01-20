class Item
  class HackerNews
    class News
      include ActionView::Helpers::UrlHelper
      include ActionView::Helpers::OutputSafetyHelper

      delegate :url, to: :extras

      def initialize(item)
        @item = item
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
                    "sources.hacker_news.news.comments",
                    count: comments_count
                  ),
                href: comments_url
              )
            end
          )
        ].compact
      end

      def rss_title
        title
      end

      def rss_description
        safe_join(
          [link_to(url, url), link_to(comments_url, comments_url)],
          "<br><br>"
        )
      end

      def rss_pub_date
        item.created_at.to_formatted_s(:rfc822)
      end

      def rss_link
        url
      end

      def rss_guid
        external_id
      end

      def to_s
        title
      end

      private

      attr_reader :item

      def extras
        OpenStruct.new(item.extras)
      end

      def external_id
        item.external_id
      end

      delegate :title,
        :domain,
        :host,
        :protocol,
        :comments_url,
        :comments_count,
        :score,
        :user_id,
        :user_url,
        to: :extras
    end
  end
end
