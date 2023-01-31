class Destination
  class HourlyEmailDigest < EmailDigest
    def items
      destination.items.where(created_at: 1.hour.ago..)
    end
  end
end
