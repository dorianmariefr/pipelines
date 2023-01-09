class Item < ApplicationRecord
  belongs_to :source

  def match(filter)
    Code.evaluate(filter, ruby: payload).truthy?
  end

  def payload
    {external_id: external_id}
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

  def to_s
    subclass.to_s
  end
end
