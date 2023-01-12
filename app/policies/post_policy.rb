class PostPolicy < ApplicationPolicy
  def show?
    record.user == user || record.public_post? || (record.friends_only? && record.user.friends.include?(user))
  end

  def edit?
    record.user == user
  end

  def update?
    edit?
  end

  def destroy?
    record.user == user
  end
end