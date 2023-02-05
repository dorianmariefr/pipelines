class Source
  class Mastodon
    class Home
      class Status
        def initialize(status)
          @status = status
        end

        def external_id
          status["id"]
        end

        def extras
          status.merge(summary: text, text: text)
        end

        private

        attr_reader :status

        def text
          Nokogiri.HTML(status["content"]).text
        end
      end
    end
  end
end
