class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def alert
    errors.full_messages.to_sentence
  end
end
