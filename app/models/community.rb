class Community < ApplicationRecord
  MIN_CNAME_LEN = 2
  MAX_CNAME_LEN = 50
  MAX_DESC_LEN  = 1000

  enum type: { public: 'public', private: 'private' }, _prefix: :type
  after_initialize :set_defaults

  auto_strip_attributes :name, :description
  validates :name, presence: true,
                   length: { in: MIN_CNAME_LEN..MAX_CNAME_LEN },
                   uniqueness: true
  validates :description, presence: true, length: { maximum: MAX_DESC_LEN }
  validates :type, presence: true

  before_validation do
    self.name = name.downcase if name.present?
  end


  def set_defaults
    self.type ||= 'public'
  end
end
