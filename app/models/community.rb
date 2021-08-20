class Community < ApplicationRecord
  MIN_CNAME_LEN   = 2
  MAX_CNAME_LEN   = 50
  MAX_DESC_LEN    = 1000
  MIN_HANDLE_LEN  = 2
  MAX_HANDLE_LEN  = 4
  DEFAULT_CHANNEL_ATTRS  = [
    { name: 'general', description: 'General information' },
    { name: 'announcements', description: 'Latest news and announcements' }
  ]

  has_many :channels, dependent: :destroy
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships

  enum access: { public: 'public', private: 'private' }, _suffix: :access

  after_initialize  :set_default_access
  before_validation :upcase_handle
  after_create      :add_default_channels

  auto_strip_attributes :name, :description
  validates :name, presence: true,
                   length: { in: MIN_CNAME_LEN..MAX_CNAME_LEN },
                   uniqueness: { case_sensitive: false }
  validates :description, presence: true, length: { maximum: MAX_DESC_LEN }
  validates :handle, presence: true,
                     length: { in: MIN_HANDLE_LEN..MAX_HANDLE_LEN },
                     format: { with: /\A[A-Z]+\z/ },
                     uniqueness: true
  validates :access, presence: true


  private

    def set_default_access
      self.access ||= 'public'
    end

    def upcase_handle
      self.handle.upcase! if handle.present?
    end

    def add_default_channels
      DEFAULT_CHANNEL_ATTRS.each {|channel| self.channels.create channel }
    end
end
