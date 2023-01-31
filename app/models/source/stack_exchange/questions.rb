class Source
  class StackExchange
    class Questions
      EXPIRES_IN = 1.minute

      def fetch
        url = "https://api.stackexchange.com"
        url += "/2.3/questions?"
        url += { order: order, sort: sort, tagged: tagged, site: site }.to_query
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
