require "test_helper"

class TasksControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    @project = projects(:one)
    @task = tasks(:one)
    sign_in @user
  end

  test "should get index" do
    get project_url(@project, format: :html)
    assert_response :success
  end

  test "should get show" do
    get project_task_url(@project, @task)
    assert_response :success
  end

  test "should get new" do
    get new_project_task_url(@project)
    assert_response :success
  end

  test "should create task" do
    assert_difference("Task.count") do
      post project_tasks_url(@project), params: { task: {
        title: "New Task",
        description: "Test task",
        due_date: Date.today + 7,
        status: "pending",
        priority: "medium",
        user_id: @user.id
      } }
    end

    assert_redirected_to project_task_url(@project, Task.last)
  end

  test "should get edit" do
    get edit_project_task_url(@project, @task)
    assert_response :success
  end

  test "should update task" do
    patch project_task_url(@project, @task), params: { task: { title: "Updated Task" } }
    assert_redirected_to project_task_url(@project, @task)
  end

  test "should destroy task" do
    assert_difference("Task.count", -1) do
      delete project_task_url(@project, @task)
    end

    assert_redirected_to project_url(@project)
  end

  test "should complete task" do
    patch complete_project_task_url(@project, @task)
    assert_redirected_to project_task_url(@project, @task)
  end
end
