class Destination
  class MonthlyEmailDigest < EmailDigest
    def items
      destination.items.where(created_at: 1.month.ago..)
    end
  end
end
