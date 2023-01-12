class Item < ApplicationRecord
  belongs_to :source

  validates :external_id, uniqueness: { scope: :source_id }

  def match(filter)
    return true if filter.blank?
    Code.evaluate(filter, ruby: extras).truthy?
  end

  def subclass
    source.subclass.new(self)
  end

  def urls
    subclass.urls
  end

  def url
    subclass.url
  end

  def email_subject
    subclass.email_subject
  end

  def email_body
    subclass.email_body
  end

  def to_s
    subclass.to_s
  end
end
