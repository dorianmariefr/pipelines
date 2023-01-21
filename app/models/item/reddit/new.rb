class Item
  class Reddit
    class New
      include ActionView::Helpers::UrlHelper
      include ActionView::Helpers::OutputSafetyHelper

      def initialize(item)
        @item = item
      end

      delegate :url, to: :extras

      def urls
        []
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
        id
      end

      def to_s
        title
      end

      private

      attr_reader :item

      def extras
        OpenStruct.new(item.extras)
      end

      delegate :id, :title, :url, to: :extras
    end
  end
end
