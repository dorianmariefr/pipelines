class Admin
  class PhoneNumberPolicy < AdminPolicy
    def send_verification?
      admin?
    end
  end
end
