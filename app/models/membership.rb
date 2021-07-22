class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :community

  enum role: {
    owner: 'owner',
    administrator: 'administrator',
    regular: 'regular',
    banned: 'banned'
  }
  after_initialize :set_defaults

  validates :role, presence: true


  def set_defaults
    self.role ||= 'regular'
  end
end
