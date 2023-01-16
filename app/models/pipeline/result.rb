class Pipeline
  class Result
    attr_reader :source_results, :destination_results

    def initialize(source_results:, destination_results:)
      @source_results = source_results
      @destination_results = destination_results
    end

    def new_items
      source_results.map(&:new_items).flatten
    end

    def new_items_to_s
      I18n.t("pipelines.result.new_items", count: new_items.size)
    end

    def matched_items
      source_results.map(&:matched_items).flatten
    end

    def matched_items_to_s
      I18n.t("pipelines.result.matched_items", count: matched_items.size)
    end

    def saved_items
      source_results.map(&:saved_items).flatten
    end

    def saved_items_to_s
      I18n.t("pipelines.result.saved_items", count: saved_items.size)
    end

    def sent_items
      destination_results.map(&:sent_items).flatten
    end

    def sent_items_to_s
      I18n.t("pipelines.result.sent_items", count: sent_items.size)
    end

    def to_s
      [
        new_items_to_s,
        matched_items_to_s,
        saved_items_to_s,
        sent_items_to_s
      ].to_sentence
    end
  end
end
