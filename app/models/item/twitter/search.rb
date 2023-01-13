class Item
  class Twitter
    class Search
      include ActionView::Helpers::UrlHelper
      include ActionView::Helpers::OutputSafetyHelper

      def initialize(item)
        @item = item
      end

      delegate :url, to: :extras

      def urls
        [
          Url.new(text: user_handle, href: user_url),
          (
            if user_profile_url
              Url.new(text: user_profile_url, href: user_profile_url)
            end
          )
        ].compact
      end

      def email_subject
        text
      end

      def email_body
        "#{url}\n\n#{user_url}"
      end

      def rss_title
        text
      end

      def rss_description
        safe_join([link_to(url, url), link_to(user_url, user_url)], "<br><br>")
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
        text
      end

      private

      attr_reader :item

      def extras
        Struct.new(*item.extras.deep_symbolize_keys.keys).new(
          *item.extras.values
        )
      end

      delegate :id,
               :text,
               :user_url,
               :user_profile_url,
               :user_handle,
               to: :extras
    end
  end
end
