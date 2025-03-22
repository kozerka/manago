class ProjectsController < ApplicationController
  before_action :set_project, only: [ :show, :edit, :update, :destroy, :archive, :complete ]

  def index
    @projects = policy_scope(Project).active.order(created_at: :desc)
    @archived_projects = policy_scope(Project).where(status: :archived).order(created_at: :desc)
  end

  def show
    @tasks = @project.tasks.order(due_date: :asc)
  end

  def new
    @project = Project.new
    authorize @project
  end

  def create
    @project = current_user.projects.build(project_params)
    authorize @project

    if @project.save
      redirect_to @project, notice: "Project was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @project.update(project_params)
      redirect_to @project, notice: "Project was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @project.destroy
    redirect_to projects_path, notice: "Project was successfully deleted."
  end

  def archive
    if @project.update(status: :archived)
      redirect_to projects_path, notice: "Project was successfully archived."
    else
      redirect_to @project, alert: "Failed to archive project."
    end
  end

  def complete
    if @project.update(status: :completed)
      redirect_to @project, notice: "Project was successfully marked as completed."
    else
      redirect_to @project, alert: "Failed to complete project."
    end
  end

  private

  def set_project
    @project = Project.find(params[:id])
    authorize @project
  end

  def project_params
    params.require(:project).permit(:title, :description, :start_date, :end_date, :status)
  end
end
