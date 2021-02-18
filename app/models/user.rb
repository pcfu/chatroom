class User < ApplicationRecord
  has_secure_password
  auto_strip_attributes :username, :email

  validates :username, presence: true, length: { in: 3..15 },
                       format: { with: /\A([a-zA-Z0-9]+(_|-)?)*[a-zA-Z0-9]\z/ },
                       uniqueness: true
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: true
  validates :password, presence: true, length: { minimum: 8, maximum: 30 },
                       format: { with: /(?=.*?[a-zA-Z])(?=.*?[0-9])(?=.?[#?!@$%^&*_-])/ }

  before_save do
    self.email = email.downcase
  end
end
