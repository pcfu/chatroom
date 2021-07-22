class Community < ApplicationRecord
  has_many :memberships
  has_many :users, through: :memberships

  MIN_CNAME_LEN   = 2
  MAX_CNAME_LEN   = 50
  MAX_DESC_LEN    = 1000
  MIN_HANDLE_LEN  = 2
  MAX_HANDLE_LEN  = 4

  enum access: { public: 'public', private: 'private' }, _suffix: :access
  after_initialize :set_defaults

  auto_strip_attributes :name, :description
  validates :name, presence: true,
                   length: { in: MIN_CNAME_LEN..MAX_CNAME_LEN },
                   uniqueness: true
  validates :description, presence: true, length: { maximum: MAX_DESC_LEN }
  validates :handle, presence: true,
                     length: { in: MIN_HANDLE_LEN..MAX_HANDLE_LEN },
                     uniqueness: true
  validates :access, presence: true

  before_validation do
    self.name = name.downcase if name.present?
    self.handle = handle.upcase if handle.present?
  end


  def set_defaults
    self.access ||= 'public'
  end
end
