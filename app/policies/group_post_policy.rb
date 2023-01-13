class GroupPostPolicy < ApplicationPolicy
  def show?
    record.group.user_groups.normal.pluck(:user_id).include?(user.id) ||
      record.group.user_groups.moderator.pluck(:user_id).include?(user.id) ||
      record.group.user_groups.admin.pluck(:user_id).include?(user.id) ||
      record.group.public_group?
  end

  def edit?
    record.user_group.user == user
  end

  def update?
    edit?
  end

  def destroy?
    record.user_group.user == user
  end
end