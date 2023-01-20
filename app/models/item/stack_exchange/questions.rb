class Item
  class StackExchange
    class Questions
      include ActionView::Helpers::UrlHelper
      include ActionView::Helpers::OutputSafetyHelper

      def initialize(item)
        @item = item
      end

      delegate :url, to: :extras

      def urls
        [Url.new(text: owner_display_name, href: owner_url)]
      end

      def rss_title
        title
      end

      def rss_description
        link_to(url, url)
      end

      def rss_pub_date
        item.created_at.to_formatted_s(:rfc822)
      end

      def rss_link
        url
      end

      def rss_guid
        question_id
      end

      def to_s
        title
      end

      private

      attr_reader :item

      def extras
        OpenStruct.new(item.extras)
      end

      delegate :question_id,
        :title,
        :url,
        :owner_display_name,
        :owner_url,
        to: :extras
    end
  end
end
