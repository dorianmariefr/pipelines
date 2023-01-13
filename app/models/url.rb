class Url
  attr_reader :text, :href

  def initialize(text:, href:)
    @text = text
    @href = href
  end
end
