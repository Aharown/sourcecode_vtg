class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :profile_photo
  has_many :bookings
  has_many :garments, dependent: :nullify

  attribute :admin, :boolean, default: false

  def admin?
    self.admin
  end
end
