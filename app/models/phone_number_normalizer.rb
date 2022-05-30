class PhoneNumberNormalizer
  def self.normalize(phone_number)
    Phonelib.parse(phone_number).e164
  end
end
