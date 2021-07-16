class User < ApplicationRecord
  MIN_UNAME_LEN = 3
  MAX_UNAME_LEN = 20
  MAX_EMAIL_LEN = 255
  DOB_YEAR_RANGE = 150
  MIN_USER_AGE = 13
  MIN_PW_LEN = 8
  MAX_PW_LEN = 30

  class << self
    def max_dob
      Date.current.advance(years: -MIN_USER_AGE)
    end

    def dob_years
      max_year = max_dob.year
      max_year.downto(max_year - DOB_YEAR_RANGE).to_a
    end

    def create_keys
      [:username, :email, :dob, :password, :password_confirmation]
    end
  end

  has_secure_password
  auto_strip_attributes :username, :email
  validates :username, presence: true,
                       length: { in: MIN_UNAME_LEN..MAX_UNAME_LEN },
                       format: { with: /\A[a-zA-Z0-9](\w|-)+[a-zA-Z0-9]\z/ },
                       uniqueness: { case_sensitive: false }
  validates :email, presence: true,
                    length: { maximum: MAX_EMAIL_LEN },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: true
  validates :dob, presence: true, date: { max: max_dob }
  validates :password, presence: true,
                       length: { in: MIN_PW_LEN..MAX_PW_LEN },
                       format: { with: /(?=.*?[a-zA-Z])(?=.*?[0-9])(?=.*?[#?!@$%^&*_-])/ }

  before_validation do
    self.email = email.downcase if email.present?
  end
end
