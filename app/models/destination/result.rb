class Destination
  class Result
    attr_reader :sent_items, :error

    def initialize(sent_items: [], error: nil)
      @sent_items = sent_items
      @error = error
    end
  end
end
