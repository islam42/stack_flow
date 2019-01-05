class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :name, presence: true

  has_many :questions,  dependent: :destroy
  has_many :answers,    dependent: :destroy
  has_many  :comments,  dependent: :destroy
  # has_many  :votes,  dependent: :destroy

end
