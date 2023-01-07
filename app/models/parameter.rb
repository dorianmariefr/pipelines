class Parameter < ApplicationRecord
  belongs_to :parameterizable, polymorphic: true
end
