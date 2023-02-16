class User < ApplicationRecord
  has_one_attached :avatar
  validate :avatar_content_type

  private

  def avatar_content_type
    if avatar.attached? && !avatar.content_type.in?(%w(image/jpeg image/png image/gif))
      errors.add(:avatar, 'must be a valid image format')
    end
  end
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
        
end
