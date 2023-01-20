class Source
  class StackExchange
    class Questions
      EXPIRES_IN = 1.minute

      def initialize(source)
        @source = source
      end

      def self.keys
        %w[
          title
          url
          tags
          owner_account_id
          owner_reputation
          owner_user_id
          owner_user_type
          owner_profile_image
          owner_display_name
          owner_url
          answered?
          views
          answers
          score
          last_activity_date
          creation_date
          question_id
          content_license
        ]
      end

      def self.as_json
        {
          keys: keys,
          parameters: {
            tagged: {
              default: "",
              kind: :string
            },
            sort: {
              default: :creation,
              kind: :select,
              translate: false,
              options: Parameter::SORT
            },
            order: {
              default: :desc,
              kind: :select,
              options: Parameter::ORDERS
            },
            site: {
              default: :stackoverflow,
              kind: :select,
              translate: false,
              options: Parameter::SITES
            }
          }
        }
      end

      def self.email_subject_default
        "{title}"
      end

      def self.email_body_default
        <<~TEMPLATE
          {title}

          {url}

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
          end
          nothing}

          {pipeline.url}
        TEMPLATE
      end

      def as_json
        self.class.as_json
      end

      def fetch
        url = "https://api.stackexchange.com"
        url += "/2.3/questions?"
        url += {order: order, sort: sort, tagged: tagged, site: site}.to_query
        response =
          Rails
            .cache
            .fetch([self.class.name, url], expires_in: EXPIRES_IN) do
              Net::HTTP.get(URI(url))
            end
        JSON
          .parse(response, object_class: OpenStruct)
          .items
          .map { |question| Question.new(question) }
      end

      private

      attr_reader :source

      delegate :order, :sort, :tagged, :site, to: :params

      def params
        OpenStruct.new(source.params)
      end
    end
  end
end
