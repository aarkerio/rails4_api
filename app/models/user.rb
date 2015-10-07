class User < ActiveRecord::Base
  belongs_to :group

  validates :guid,  :presence: true, :uniqueness: true
  validates :email, :presence: true, :uniqueness: true
end
