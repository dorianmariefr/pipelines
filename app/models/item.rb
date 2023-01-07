class Item < ApplicationRecord
  belongs_to :source

  def match(filter)
    Code.evaluate(filter, ruby: payload).truthy?
  end

  def payload
    {
      subject: subject,
      body: body,
      keywords: keywords,
      external_id: external_id
    }
  end

  def keywords
    subject.split(/[^[[:word:]]]+/)
  end
end
