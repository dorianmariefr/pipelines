class PhoneNumberPolicy < ApplicationPolicy
  def send_verification?
    owner? || admin?
  end

  def show?
    owner? || admin?
  end

  def create?
    owner? || admin?
  end

  def update?
    owner? || admin?
  end

  def destroy?
    (owner? && (phone_numbers.many? || emails.any?)) || admin?
  end

  class Scope < Scope
    def resolve
      if admin?
        scope.all
      elsif current_user?
        scope.where(user: current_user)
      else
        scope.none
      end
    end
  end

  private

  def user
    record.user
  end

  def user?
    !!user
  end

  def owner?
    user? && current_user? && user == current_user
  end

  def phone_numbers
    user.phone_numbers
  end

  def emails
    user.emails
  end
end
