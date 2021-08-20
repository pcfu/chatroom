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

  validates_uniqueness_of :community_id, scope: :user_id
  validates :role, presence: true


  private

    def set_defaults
      self.role ||= 'regular'
    end
end
