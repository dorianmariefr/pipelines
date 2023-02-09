class Source
  class StackExchange
    class Questions
      EXPIRES_IN = 1.minute

      DEFAULT_ORDER = "desc"
      ORDERS = %i[desc asc].map { |order| [order, order] }

      DEFAULT_SORT = "creation"
      SORTS =
        %i[activity votes creation hot week month].map { |sort| [sort, sort] }

      DEFAULT_SITE = "stackoverflow.com"
      SITES =
        File
          .read(Rails.root.join("lib", "data", "sites.txt"))
          .split
          .map { |site| [site, site] }

      def initialize(source)
        @source = source
      end

      def self.tags
        File.read(Rails.root.join("lib", "data", "tags.txt")).split
      end

      def self.fake_tags
        tags.sample(3)
      end

      def self.parameters_for(_user)
        [
          {
            name: :site,
            type: :select,
            default: DEFAULT_SITE,
            options: SITES,
            scope: :stack_exchange
          },
          {
            name: :tagged,
            type: :string,
            fakes: fake_tags,
            scope: :stack_exchange
          },
          {
            name: :sort,
            type: :list,
            default: DEFAULT_SORT,
            options: SORTS,
            scope: :stack_exchange
          },
          {
            name: :order,
            type: :list,
            default: DEFAULT_ORDER,
            options: ORDERS,
            scope: :stack_exchange
          }
        ]
      end

      def self.keys
        %w[
          summary
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
