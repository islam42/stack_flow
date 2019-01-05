class Comment < ActiveRecord::Base
  validates :body, presence: true, length: {maximum: 254}
  validates :user_id, presence:true
  validates :commentable_type, presence: true 
  validates :commentable_id, presence: true

  belongs_to :user
  belongs_to :commentable, polymorphic: true
   
end
