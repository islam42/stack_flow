class Vote < ActiveRecord::Base
  validates :user_id, presence: true
  validates :votable_type, presence: true
  validates :votable_id, presence: true
  validates :value, presence: true

  belongs_to :user
  belongs_to :votable, polymorphic: true
  belongs_to :votable, polymorphic: true
end
