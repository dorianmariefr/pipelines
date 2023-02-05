module OmniAuth
  module Strategies
    class SomeSite < OmniAuth::Strategies::OAuth2
      option :name, "mastodon"

      option :client_options, -> {
      }

      # These are called after authentication has succeeded. If
      # possible, you should try to set the UID without making
      # additional calls (if the user id is returned with the token
      # or as a URI parameter). This may not be possible with all
      # providers.
      uid { raw_info["id"] }

      info do
        {
          name: raw_info["name"],
          email: raw_info["email"]
        }
      end

      extra do
        {
          "raw_info" => raw_info
        }
      end

      def raw_info
        @raw_info ||= access_token.get("/me").parsed
      end
    end
  end
end
