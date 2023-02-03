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
            summary: data.title,
            title: data.title,
            kind: listing.kind,
            subreddit: data.subreddit,
            subreddit_url: subreddit_url,
            comments_url: comments_url,
            permalink: data.permalink,
            subreddit_type: data.subreddit_type,
            comments: data.num_comments,
            ups: data.ups,
            downs: data.downs,
            score: data.score,
            thumbnail: data.thumbnail,
            selftext_html: data.selftext_html,
            views: data.view_count,
            url: data.url,
            id: data.id
          }
        end

        private

        attr_accessor :listing

        delegate :data, to: :listing

        def subreddit_url
          "#{BASE_URL}/r/#{data.subreddit}"
        end

        def comments_url
          "#{BASE_URL}#{data.permalink}"
        end
      end
    end
  end
end
