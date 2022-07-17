class Source < ApplicationRecord
  belongs_to :pipeline

  has_many :parameters, as: :parameterable
end
