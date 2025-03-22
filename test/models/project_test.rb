require "test_helper"

class ProjectTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
    @project = Project.create(
      title: "Test Project",
      description: "A test project for unit tests",
      start_date: Date.today - 10.days,
      end_date: Date.today + 20.days,
      status: :in_progress,
      user: @user
    )
  end

  test "should be valid with valid attributes" do
    assert @project.valid?
  end

  test "should not be valid without title" do
    @project.title = nil
    assert_not @project.valid?
  end

  test "should not be valid without start date" do
    @project.start_date = nil
    assert_not @project.valid?
  end

  test "should not be valid with end date before start date" do
    @project.end_date = @project.start_date - 1.day
    assert_not @project.valid?
  end

  test "should calculate time progress percentage correctly" do
    # For a project 10 days in with 30 days total duration
    assert_equal 33, @project.time_progress_percentage
  end

  test "should return 0 progress for future projects" do
    future_project = Project.create(
      title: "Future Project",
      description: "A project that hasn't started yet",
      start_date: Date.today + 10.days,
      end_date: Date.today + 30.days,
      status: :draft,
      user: @user
    )

    assert_equal 0, future_project.time_progress_percentage
  end

  test "should return 100 progress for finished projects" do
    past_project = Project.create(
      title: "Past Project",
      description: "A project that is already finished",
      start_date: Date.today - 30.days,
      end_date: Date.today - 5.days,
      status: :completed,
      user: @user
    )

    assert_equal 100, past_project.time_progress_percentage
  end

  test "should calculate task completion percentage correctly" do
    # Create a few tasks for the project
    3.times do |i|
      Task.create(
        title: "Task #{i+1}",
        description: "Test task",
        due_date: Date.today + i.days,
        priority: :medium,
        status: i < 2 ? :completed : :pending,
        project: @project,
        user: @user
      )
    end

    # With 2 of 3 tasks completed, should be 67%
    assert_equal 67, @project.task_completion_percentage
  end

  test "should return 0 for task completion with no tasks" do
    assert_equal 0, @project.task_completion_percentage
  end

  test "should return task stats by status" do
    # Create tasks with different statuses
    Task.create(title: "Pending Task", status: :pending, due_date: Date.today, priority: :medium, project: @project, user: @user)
    Task.create(title: "In Progress Task", status: :in_progress, due_date: Date.today, priority: :medium, project: @project, user: @user)
    Task.create(title: "Completed Task 1", status: :completed, due_date: Date.today, priority: :medium, project: @project, user: @user)
    Task.create(title: "Completed Task 2", status: :completed, due_date: Date.today, priority: :medium, project: @project, user: @user)

    stats = @project.task_stats_by_status
    assert_equal 1, stats[:pending]
    assert_equal 1, stats[:in_progress]
    assert_equal 2, stats[:completed]
    assert_equal 0, stats[:cancelled]
  end

  test "should return task stats by priority" do
    # Create tasks with different priorities
    Task.create(title: "Low Priority", priority: :low, status: :pending, due_date: Date.today, project: @project, user: @user)
    Task.create(title: "Medium Priority 1", priority: :medium, status: :pending, due_date: Date.today, project: @project, user: @user)
    Task.create(title: "Medium Priority 2", priority: :medium, status: :pending, due_date: Date.today, project: @project, user: @user)
    Task.create(title: "High Priority", priority: :high, status: :pending, due_date: Date.today, project: @project, user: @user)

    stats = @project.task_stats_by_priority
    assert_equal 1, stats[:low]
    assert_equal 2, stats[:medium]
    assert_equal 1, stats[:high]
    assert_equal 0, stats[:urgent]
  end
end
