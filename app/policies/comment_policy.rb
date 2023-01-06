class CommentPolicy < ApplicationPolicy
  def current_user?
    record.user == user
  end

  def update?
    current_user?
  end

  def destroy?
    current_user?
  end
end