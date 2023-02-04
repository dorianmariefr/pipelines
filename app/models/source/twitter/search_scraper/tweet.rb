class Source
  class Twitter
    class SearchScraper
      class Tweet
        BASE_URL = "https://twitter.com"

        def initialize(tweet, users:)
          @tweet = tweet
          @users = users
        end

        def external_id
          tweet.id.to_s
        end

        def extras
          {
            summary: tweet.full_text,
            id: tweet.id.to_s,
            url: url,
            text: tweet.full_text,
            created_at: tweet.created_at,
            quote?: tweet.quoted_status?,
            retweets: tweet.retweet_count,
            likes: tweet.favorite_count,
            lang: tweet.lang,
            user_id: user.id.to_s,
            user_name: user.name,
            user_handle: user.screen_name,
            user_location: user.location,
            user_description: user.description,
            user_url: user_url,
            user_profile_url: user.url.to_s,
            user_protected: user.protected?,
            user_followers: user.followers_count,
            user_friends: user.friends_count,
            user_listed: user.listed_count,
            user_created_at: user.created_at,
            user_likes: user.favorites_count,
            user_verified: user.verified?,
            user_tweets: user.statuses_count,
            user_background_image_url:
              user.profile_background_image_url_https.to_s,
            user_image_url: user.profile_image_url_https.to_s
          }
        end

        def to_s
          extras.to_s
        end

        def inspect
          extras.inspect
        end

        private

        attr_reader :tweet, :users

        def user
          users[tweet.user_id.to_s]
        end

        def url
          "#{BASE_URL}/#{user.screen_name}/status/#{tweet.id}"
        end

        def user_url
          "#{BASE_URL}/#{user.screen_name}"
        end
      end
    end
  end
end