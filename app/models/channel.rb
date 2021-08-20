class Channel < ApplicationRecord
  MIN_NAME_LEN = 2
  MAX_NAME_LEN = 20
  MAX_DESC_LEN = 1000

  belongs_to :community
  auto_strip_attributes :name, :description

  validates :name, presence: true,
                   length: { in: MIN_NAME_LEN..MAX_NAME_LEN },
                   format: { with: /\A([a-zA-Z0-9]+\-?)+[a-zA-Z0-9]+\z/ },
                   uniqueness: { scope: :community_id }
  validates :description, length: { maximum: MAX_DESC_LEN }

  before_validation :downcase_name

  private

    def downcase_name
      self.name.downcase! if name.present?
    end
end
