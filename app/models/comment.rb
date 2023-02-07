class Comment < ApplicationRecord
  belongs_to :users
  validates :comment, presence: true
end 
