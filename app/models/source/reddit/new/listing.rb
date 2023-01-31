class Source
  class Reddit
    class New
      class Listing
        def initialize(listing)
          self.listing = listing
        end

        def external_id
          data.id
        end

        def extras
          {
            title: data.title,
            kind: listing.kind,
            subreddit: data.subreddit,
            subreddit_type: data.subreddit_type,
            ups: data.ups,
            downs: data.downs,
            score: data.score,
            thumbnail: data.thumbnail,
            selftext_html: data.selftext_html,
            views: data.view_count,
            url: data.url,
            id: data.id,
            summary: summary,
            to_text: to_text,
            to_html: to_html
          }
        end

        private

        attr_accessor :listing

        delegate :data, to: :listing

        def summary
          data.title
        end

        def to_text
          <<~TEXT
            #{data.title}

            #{data.url}
          TEXT
        end

        def to_html
          ApplicationController.render(
            partial: "reddit/listing",
            layout: "",
            locals: {
              title: data.title,
              url: data.url
            }
          )
        end
      end
    end
  end
end
