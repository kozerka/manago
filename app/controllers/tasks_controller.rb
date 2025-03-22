class TasksController < ApplicationController
  before_action :set_project
  before_action :set_task, only: [ :show, :edit, :update, :destroy, :complete, :update_checklist ]

  def index
  end

  def show
    @comments = @task.comments.includes(:user)
    @comment = Comment.new
  end

  def new
    @task = @project.tasks.build
    authorize @task
  end

  def create
    @task = @project.tasks.build(task_params)
    @task.user = current_user
    authorize @task

    if @task.save
      redirect_to project_task_path(@project, @task), notice: "Task was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      redirect_to project_task_path(@project, @task), notice: "Task was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
    redirect_to project_path(@project), notice: "Task was successfully deleted."
  end

  def complete
    @task.complete!
    redirect_to project_task_path(@project, @task), notice: "Task was marked as completed."
  end

  def update_checklist
    checklist = @task.checklist || []

    case params[:action_type]
    when "add"
      checklist << { "id" => SecureRandom.uuid, "text" => params[:text], "completed" => false }
    when "toggle"
      item = checklist.find { |item| item["id"] == params[:item_id] }
      item["completed"] = !item["completed"] if item
    when "update"
      item = checklist.find { |item| item["id"] == params[:item_id] }
      item["text"] = params[:text] if item
    when "remove"
      checklist.delete_if { |item| item["id"] == params[:item_id] }
    end

    @task.update(checklist: checklist)

    respond_to do |format|
      format.html { redirect_to project_task_path(@project, @task) }
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace("checklist-items", partial: "tasks/checklist_items", locals: { task: @task }),
          turbo_stream.replace("checklist-progress", partial: "tasks/checklist_progress", locals: { task: @task })
        ]
      end
    end
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_task
    @task = @project.tasks.find(params[:id])
    authorize @task
  end

  def task_params
    params.require(:task).permit(:title, :description, :due_date, :status, :priority, checklist: [])
  end
end
