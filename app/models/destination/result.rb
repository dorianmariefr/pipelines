class Destination
  class Result
    attr_reader :sent_items

    def initialize(sent_items: [])
      @sent_items = sent_items
    end
  end
end
