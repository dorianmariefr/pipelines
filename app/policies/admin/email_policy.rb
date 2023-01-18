class Admin
  class EmailPolicy < AdminPolicy
    def send_verification?
      admin?
    end
  end
end
