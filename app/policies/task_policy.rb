class TaskPolicy < ApplicationPolicy
  def show?
    record.project.user_id == user.id || user.admin?
  end

  def create?
    record.project.user_id == user.id || user.admin?
  end

  def update?
    record.project.user_id == user.id || user.admin?
  end

  def destroy?
    record.project.user_id == user.id || user.admin?
  end

  def complete?
    record.project.user_id == user.id || user.admin?
  end

  def update_checklist?
    record.project.user_id == user.id || user.admin?
  end

  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      else
        scope.joins(:project).where(projects: { user_id: user.id })
      end
    end
  end
end
