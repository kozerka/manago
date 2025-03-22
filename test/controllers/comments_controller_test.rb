require "test_helper"

class CommentsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    @project = projects(:one)
    @task = tasks(:one)
    @comment = comments(:one)
    sign_in @user
  end

  test "should create comment" do
    assert_difference("Comment.count") do
      post project_task_comments_url(@project, @task), params: { comment: { content: "New comment" } }
    end

    assert_redirected_to project_task_url(@project, @task)
  end

  test "should get edit" do
    get edit_project_task_comment_url(@project, @task, @comment)
    assert_response :success
  end

  test "should update comment" do
    patch project_task_comment_url(@project, @task, @comment), params: { comment: { content: "Updated comment" } }
    assert_redirected_to project_task_url(@project, @task)
  end

  test "should destroy comment" do
    assert_difference("Comment.count", -1) do
      delete project_task_comment_url(@project, @task, @comment)
    end

    assert_redirected_to project_task_url(@project, @task)
  end
end
