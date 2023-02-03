class Source
  class Result
    attr_accessor :new_items, :matched_items, :saved_items

    def initialize(new_items: [], matched_items: [], saved_items: [])
      @new_items = new_items
      @matched_items = matched_items
      @saved_items = saved_items
    end
  end
end
