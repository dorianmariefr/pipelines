class Item < ApplicationRecord
  belongs_to :source

  def match(filter)
    Code.evaluate(filter, ruby: payload).truthy?
  end

  def payload
    {
      title: title,
      subject: subject,
      body: body,
      keywords: keywords,
      external_id: external_id
    }
  end

  def title
    subject
  end

  def keywords
    subject.split(/[^[[:word:]]]+/)
  end
end
