class Vote < ActiveRecord::Base
  validates :user, presence: true
  validates :votable, presence: true
  validates :value, presence: true

  belongs_to :user
  belongs_to :votable, polymorphic: true
  belongs_to :votable, polymorphic: true
end
