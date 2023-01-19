class Source
  class HackerNews
    class News
      BASE_URL = "https://news.ycombinator.com"
      TARGET_URL = BASE_URL
      EXPIRES_IN = 1.minute

      def initialize(source)
        @source = source
      end

      def self.as_json
        {}
      end

      def self.email_subject_default
        "{title}"
      end

      def self.email_body_default
        <<~TEMPLATE
          {url}

          {comments_url}

          {pipeline.url}
        TEMPLATE
      end

      def self.email_digest_subject_default
        "{items.first.title}"
      end

      def self.email_digest_body_default
        <<~TEMPLATE
          {items.each do |item|
            puts(item.title)
            puts
            puts(item.url)
            puts
            puts(item.comments_url)
            puts
          end
          nothing}

          {pipeline.url}
        TEMPLATE
      end

      def as_json
        self.class.as_json
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
