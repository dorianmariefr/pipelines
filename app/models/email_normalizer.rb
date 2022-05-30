class EmailNormalizer
  def self.normalize(email)
    Normailize::EmailAddress.new(email).normalized_address
  rescue ArgumentError
    email
  end
end
