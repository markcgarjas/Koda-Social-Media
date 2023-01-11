class UserGroupPolicy < ApplicationPolicy
  def show?
    record.user_groups.normal.pluck(:user_id).include?(user.id) ||
      record.user_groups.admin.pluck(:user_id).include?(user.id) ||
      record.user_groups.moderator.pluck(:user_id).include?(user.id)
  end

  def edit?
    record.user_groups.admin.pluck(:user_id).include?(user.id)
  end

  def update?
    edit?
  end

  def destroy?
    record.user_groups.admin.pluck(:user_id).include?(user.id)
  end
end