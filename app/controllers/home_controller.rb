class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :index ]

  def index
    if user_signed_in?
      @projects = policy_scope(Project).order(created_at: :desc).limit(5)
      @tasks = policy_scope(Task).where.not(status: :completed).order(due_date: :asc).limit(5)
    end
  end
end
