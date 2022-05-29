class ApplicationPolicy
  def initialize(current_user, record)
    @current_user = current_user
    @record = record
  end

  def new?
    create?
  end

  def edit?
    update?
  end

  class Scope
    def initialize(current_user, scope)
      @current_user = current_user
      @scope = scope
    end

    def resolve
      raise NotImplementedError
    end

    private

    attr_reader :current_user, :scope

    def current_user?
      !!current_user
    end

    def admin?
      current_user? && current_user.admin?
    end
  end

  private

  attr_reader :current_user, :record

  def current_user?
    !!current_user
  end

  def admin?
    current_user? && current_user.admin?
  end
end
