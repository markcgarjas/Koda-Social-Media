class GroupPolicy < ApplicationPolicy
  def show?
    record.user_groups.normal.pluck(:user_id).include?(user.id) ||
      record.user_groups.admin.pluck(:user_id).include?(user.id) ||
      record.user_groups.moderator.pluck(:user_id).include?(user.id)
  end

  def edit?
    record.user_groups.admin.pluck(:user_id).include?(user.id) ||
      record.user_groups.moderator.pluck(:user_id).include?(user.id)
  end

  def update?
    edit?
  end

  def cancel?
    record.user_groups.pluck(:user_id).include?(user.id)
  end

  def accept?
    record.user_groups.pluck(:user_id).include?(user.id)
  end

  def delete?
    record.user_groups.pluck(:user_id).include?(user.id)
  end

  def destroy?
    record.user_groups.admin.pluck(:user_id).include?(user.id)
  end
end