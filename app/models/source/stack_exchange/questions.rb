class Source
  class StackExchange
    class Questions
      EXPIRES_IN = 1.minute

      ORDERS = %i[desc asc].map { |order| [order, order] }

      SORT =
        %i[activity votes creation hot week month].map { |sort| [sort, sort] }

      SITES =
        %w[
          stackoverflow.com
          serverfault.com
          superuser.com
          askubuntu.com
          stackapps.com
          meta.stackexchange.com
          webapps.stackexchange.com
          gaming.stackexchange.com
          webmasters.stackexchange.com
          cooking.stackexchange.com
          gamedev.stackexchange.com
          photo.stackexchange.com
          stats.stackexchange.com
          math.stackexchange.com
          diy.stackexchange.com
          gis.stackexchange.com
          tex.stackexchange.com
          money.stackexchange.com
          english.stackexchange.com
          ux.stackexchange.com
          unix.stackexchange.com
          wordpress.stackexchange.com
          cstheory.stackexchange.com
          apple.stackexchange.com
          rpg.stackexchange.com
          bicycles.stackexchange.com
          softwareengineering.stackexchange.com
          electronics.stackexchange.com
          android.stackexchange.com
          boardgames.stackexchange.com
          physics.stackexchange.com
          homebrew.stackexchange.com
          security.stackexchange.com
          writing.stackexchange.com
          video.stackexchange.com
          graphicdesign.stackexchange.com
          dba.stackexchange.com
          scifi.stackexchange.com
          codereview.stackexchange.com
          codegolf.stackexchange.com
          quant.stackexchange.com
          pm.stackexchange.com
          skeptics.stackexchange.com
          fitness.stackexchange.com
          drupal.stackexchange.com
          mechanics.stackexchange.com
          parenting.stackexchange.com
          sharepoint.stackexchange.com
          music.stackexchange.com
          sqa.stackexchange.com
          judaism.stackexchange.com
          german.stackexchange.com
          japanese.stackexchange.com
          philosophy.stackexchange.com
          gardening.stackexchange.com
          travel.stackexchange.com
          crypto.stackexchange.com
          dsp.stackexchange.com
          french.stackexchange.com
          christianity.stackexchange.com
          bitcoin.stackexchange.com
          linguistics.stackexchange.com
          hermeneutics.stackexchange.com
          history.stackexchange.com
          bricks.stackexchange.com
          spanish.stackexchange.com
          scicomp.stackexchange.com
          movies.stackexchange.com
          chinese.stackexchange.com
          biology.stackexchange.com
          poker.stackexchange.com
          mathematica.stackexchange.com
          psychology.stackexchange.com
          outdoors.stackexchange.com
          martialarts.stackexchange.com
          sports.stackexchange.com
          academia.stackexchange.com
          cs.stackexchange.com
          workplace.stackexchange.com
          chemistry.stackexchange.com
          chess.stackexchange.com
          raspberrypi.stackexchange.com
          russian.stackexchange.com
          islam.stackexchange.com
          salesforce.stackexchange.com
          patents.stackexchange.com
          genealogy.stackexchange.com
          robotics.stackexchange.com
          expressionengine.stackexchange.com
          politics.stackexchange.com
          anime.stackexchange.com
          magento.stackexchange.com
          ell.stackexchange.com
          sustainability.stackexchange.com
          tridion.stackexchange.com
          reverseengineering.stackexchange.com
          networkengineering.stackexchange.com
          opendata.stackexchange.com
          freelancing.stackexchange.com
          blender.stackexchange.com
          mathoverflow.net
          space.stackexchange.com
          sound.stackexchange.com
          astronomy.stackexchange.com
          tor.stackexchange.com
          pets.stackexchange.com
          ham.stackexchange.com
          italian.stackexchange.com
          pt.stackoverflow.com
          aviation.stackexchange.com
          ebooks.stackexchange.com
          alcohol.stackexchange.com
          softwarerecs.stackexchange.com
          arduino.stackexchange.com
          expatriates.stackexchange.com
          matheducators.stackexchange.com
          earthscience.stackexchange.com
          joomla.stackexchange.com
          datascience.stackexchange.com
          puzzling.stackexchange.com
          craftcms.stackexchange.com
          buddhism.stackexchange.com
          hinduism.stackexchange.com
          communitybuilding.stackexchange.com
          worldbuilding.stackexchange.com
          ja.stackoverflow.com
          emacs.stackexchange.com
          hsm.stackexchange.com
          economics.stackexchange.com
          lifehacks.stackexchange.com
          engineering.stackexchange.com
          coffee.stackexchange.com
          vi.stackexchange.com
          musicfans.stackexchange.com
          woodworking.stackexchange.com
          civicrm.stackexchange.com
          medicalsciences.stackexchange.com
          ru.stackoverflow.com
          rus.stackexchange.com
          mythology.stackexchange.com
          law.stackexchange.com
          opensource.stackexchange.com
          elementaryos.stackexchange.com
          portuguese.stackexchange.com
          computergraphics.stackexchange.com
          hardwarerecs.stackexchange.com
          es.stackoverflow.com
          3dprinting.stackexchange.com
          ethereum.stackexchange.com
          latin.stackexchange.com
          languagelearning.stackexchange.com
          retrocomputing.stackexchange.com
          crafts.stackexchange.com
          korean.stackexchange.com
          monero.stackexchange.com
          ai.stackexchange.com
          esperanto.stackexchange.com
          sitecore.stackexchange.com
          iot.stackexchange.com
          literature.stackexchange.com
          vegetarianism.stackexchange.com
          ukrainian.stackexchange.com
          devops.stackexchange.com
          bioinformatics.stackexchange.com
          cseducators.stackexchange.com
          interpersonal.stackexchange.com
          iota.stackexchange.com
          stellar.stackexchange.com
          conlang.stackexchange.com
          quantumcomputing.stackexchange.com
          eosio.stackexchange.com
          tezos.stackexchange.com
          or.stackexchange.com
          drones.stackexchange.com
          mattermodeling.stackexchange.com
          cardano.stackexchange.com
          proofassistants.stackexchange.com
          substrate.stackexchange.com
          bioacoustics.stackexchange.com
          solana.stackexchange.com
        ].map { |site| [site, site] }

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
              options: SORT
            },
            order: {
              default: :desc,
              kind: :select,
              options: ORDERS
            },
            site: {
              default: :stackoverflow,
              kind: :select,
              translate: false,
              options: SITES
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
