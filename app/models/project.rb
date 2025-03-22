class Project < ApplicationRecord
  belongs_to :user
  has_many :tasks, dependent: :destroy

  enum :status, { draft: 0, in_progress: 1, completed: 2, archived: 3 }, default: :draft

  validates :title, presence: true, length: { maximum: 255 }
  validates :description, length: { maximum: 5000 }
  validates :start_date, presence: true
  validate :end_date_after_start_date, if: -> { end_date.present? && start_date.present? }

  scope :active, -> { where.not(status: :archived) }
  scope :upcoming, -> { where("start_date > ?", Date.today) }
  scope :current, -> { where("start_date <= ? AND (end_date >= ? OR end_date IS NULL)", Date.today, Date.today) }
  scope :past, -> { where("end_date < ?", Date.today) }

  def time_progress_percentage
    return 0 if start_date.nil?
    return 100 if end_date && Date.today >= end_date
    return 0 if Date.today < start_date

    # If no end date, calculate based on 30 days from start
    if end_date.nil?
      days_since_start = (Date.today - start_date).to_i
      return [ days_since_start * 100 / 30, 100 ].min
    end

    total_days = (end_date - start_date).to_i
    return 0 if total_days <= 0

    days_passed = [ (Date.today - start_date).to_i, 0 ].max
    [ days_passed * 100 / total_days, 100 ].min
  end

  def task_completion_percentage
    return 0 if tasks.empty?
    (tasks.completed.count.to_f / tasks.count * 100).round
  end

  def task_stats_by_status
    stats = tasks.group(:status).count
    {
      pending: stats["pending"] || 0,
      in_progress: stats["in_progress"] || 0,
      completed: stats["completed"] || 0,
      cancelled: stats["cancelled"] || 0
    }
  end

  def task_stats_by_priority
    stats = tasks.group(:priority).count
    {
      low: stats["low"] || 0,
      medium: stats["medium"] || 0,
      high: stats["high"] || 0,
      urgent: stats["urgent"] || 0
    }
  end

  private

  def end_date_after_start_date
    if end_date < start_date
      errors.add(:end_date, "must be after the start date")
    end
  end
end
