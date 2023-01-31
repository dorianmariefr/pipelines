class Destination
  class DailyEmailDigest < EmailDigest
    def items
      destination.items.where(created_at: 1.day.ago..)
    end
  end
end
