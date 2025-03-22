class Comment < ApplicationRecord
  belongs_to :task
  belongs_to :user

  validates :content, presence: true, length: { maximum: 2000 }

  default_scope { order(created_at: :desc) }
end
