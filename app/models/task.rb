class Task < ApplicationRecord
  belongs_to :project
  belongs_to :user
  has_many :comments, dependent: :destroy

  enum :status, { pending: 0, in_progress: 1, completed: 2, cancelled: 3 }, default: :pending
  enum :priority, { low: 0, medium: 1, high: 2, urgent: 3 }, default: :medium

  validates :title, presence: true, length: { maximum: 255 }
  validates :description, length: { maximum: 5000 }
  validates :due_date, presence: true
  validates :priority, presence: true

  # Initialize checklist as an empty array if nil
  before_save :initialize_checklist

  scope :active, -> { where.not(status: :cancelled) }
  scope :overdue, -> { where("due_date < ? AND status != ?", Date.today, statuses[:completed]) }
  scope :upcoming, -> { where("due_date > ? AND status != ?", Date.today, statuses[:completed]) }
  scope :today, -> { where("due_date = ? AND status != ?", Date.today, statuses[:completed]) }
  scope :by_priority, -> { order(priority: :desc) }

  def complete!
    update(status: :completed)
  end

  def mark_as_completed!
    update(status: :completed)
  end

  def mark_as_in_progress!
    update(status: :in_progress)
  end

  def mark_as_pending!
    update(status: :pending)
  end

  def mark_as_cancelled!
    update(status: :cancelled)
  end

  def overdue?
    due_date < Date.today && status != "completed"
  end

  def checklist_items
    checklist || []
  end

  def checklist_item_count
    checklist_items.count
  end

  def completed_checklist_items_count
    checklist_items.count { |item| item["completed"] }
  end

  def checklist_completion_percentage
    return 0 if checklist_items.empty?
    (completed_checklist_items_count.to_f / checklist_item_count * 100).round
  end

  private

  def initialize_checklist
    self.checklist ||= []
  end
end
