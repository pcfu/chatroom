class User < ApplicationRecord
  auto_strip_attributes :username

  validates :username, presence: true, length: { in: 3..15 },
                       format: { with: /\A([a-zA-Z0-9]+(_|-)?)*[a-zA-Z0-9]\z/ }
  validates :email, presence: true, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
end
