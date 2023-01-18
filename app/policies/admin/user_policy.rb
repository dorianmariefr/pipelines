class Admin
  class UserPolicy < AdminPolicy
    def impersonate?
      admin?
    end
  end
end
