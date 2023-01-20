class Parameter < ApplicationRecord
  HOURS = (0..23).map { |hour| [hour.to_s, "#{hour}:00"] }

  DAYS_OF_WEEK =
    %i[
      monday
      tuesday
      wednesday
      thursday
      friday
      saturday
      sunday
    ].map do |day_of_week|
      [day_of_week.to_s, I18n.t("parameters.#{day_of_week}")]
    end

  DAYS_OF_MONTH =
    (1..31).map { |day_of_month| [day_of_month.to_s, day_of_month.to_s] }

  RESULT_TYPES =
    %w[mixed recent popular].map { |result_type| [result_type, result_type] }

  LIMIT_FREE = 5
  LIMITS = [1, 5, 10, 20]

  LIMITS_FREE =
    LIMITS.map do |limit|
      [
        limit.to_s,
        (
          if limit > LIMIT_FREE
            I18n.t("parameters.limit_disabled", limit: limit)
          else
            limit.to_s
          end
        ),
        limit > LIMIT_FREE
      ]
    end

  LIMITS_PRO = LIMITS.map { |limit| [limit.to_s, limit.to_s] }

  BODY_FORMATS = %w[text html].map { |body_format| [body_format, body_format] }

  ORDERS = %i[desc asc].map { |order| [order, order] }

  SORT = %i[activity votes creation hot week month].map { |sort| [sort, sort] }

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

  TRANSLATED_KEYS = %w[day_of_week body_format]

  belongs_to :parameterizable, polymorphic: true

  def translated_key
    I18n.t("parameters.#{key}")
  end

  def translated_value
    TRANSLATED_KEYS.include?(key) ? I18n.t("parameters.#{value}") : value
  end

  def duplicate_for(user)
    Parameter.new(key: key, value: value)
  end

  def to_s
    "#{translated_key}: #{translated_value}"
  end
end
