class Source
  class Result
    attr_accessor :new_items, :matched_items, :saved_items, :error

    def initialize(
      error: nil,
      new_items: [],
      matched_items: [],
      saved_items: []
    )
      @error = error
      @new_items = new_items
      @matched_items = matched_items
      @saved_items = saved_items
    end
  end
end
