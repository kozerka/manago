class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    @projects_count = @user.projects.count
    @tasks_count = @user.tasks.count
    @completed_tasks_count = @user.tasks.completed.count
    @recent_projects = @user.projects.order(created_at: :desc).limit(3)
    @recent_tasks = @user.tasks.order(created_at: :desc).limit(5)
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user

    if @user.update(user_params)
      redirect_to profile_path, notice: "Profile successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email)
  end
end
