class Parameter < ApplicationRecord
  belongs_to :parameterable, polymorphic: true
end
