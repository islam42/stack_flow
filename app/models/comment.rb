class Comment < ActiveRecord::Base
  validates :body, presence: true, length: { maximum: 254 }
  validates :user, presence: true
  validates :commentable, presence: true

  belongs_to :user
  belongs_to :commentable, polymorphic: true
  delegate :name, :id, to: :user, prefix: true
end
