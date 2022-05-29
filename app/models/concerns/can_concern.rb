module CanConcern
  private

  def can?(action, record)
    policy(record).public_send("#{action}?")
  end
end
