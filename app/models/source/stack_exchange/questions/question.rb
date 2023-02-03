class Source
  class StackExchange
    class Questions
      class Question
        def initialize(question)
          @question = question
        end

        def external_id
          question.question_id
        end

        def extras
          {
            summary: title,
            title: title,
            url: question.link,
            tags: question.tags,
            owner_account_id: owner.account_id,
            owner_reputation: owner.reputation,
            owner_user_id: owner.user_id,
            owner_user_type: owner.user_type,
            owner_profile_image: owner.profile_image,
            owner_display_name: owner.display_name,
            owner_url: owner.link,
            answered?: question.is_answered,
            views: question.view_count,
            answers: question.answer_count,
            score: question.score,
            last_activity_date: question.last_activity_date,
            creation_date: question.creation_date,
            question_id: question.question_id,
            content_license: question.content_license
          }
        end

        private

        attr_reader :question

        delegate :owner, to: :question

        def title
          HTMLEntities.new.decode(question.title)
        end
      end
    end
  end
end
