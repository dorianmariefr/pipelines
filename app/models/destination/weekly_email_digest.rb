class Destination
  class WeeklyEmailDigest < EmailDigest
    def items
      destination.items.where(created_at: 1.week.ago..)
    end
  end
end
