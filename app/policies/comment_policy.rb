class CommentPolicy < ApplicationPolicy
  def create?
    record.task.project.user_id == user.id || user.admin?
  end

  def update?
    record.user_id == user.id || user.admin?
  end

  def destroy?
    record.user_id == user.id || record.task.project.user_id == user.id || user.admin?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
