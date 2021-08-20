require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { build_stubbed :user }
  let(:ctrl_user) { create :control_user }

  it { is_expected.to be_valid }

  describe "#username" do
    it "is required" do
      blank_strings.each do |username|
        user.username = username
        user.valid?
        expect(user.errors[:username]).to include("can't be blank")
      end
    end

    it "has at least #{User::MIN_UNAME_LEN} chars" do
      user.username = attributes_for(:user, :username_too_short)[:username]
      user.valid?
      expect(user.errors[:username]).to include(/is too short/)
    end

    it "has at most #{User::MAX_UNAME_LEN} chars" do
      user.username = attributes_for(:user, :username_too_long)[:username]
      user.valid?
      expect(user.errors[:username]).to include(/is too long/)
    end

    it "has no spaces" do
      user.username = attributes_for(:user, :username_with_spaces)[:username]
      user.valid?
      expect(user.errors[:username]).to include("is invalid")
    end

    it "has at least 1 letter" do
      user.username = attributes_for(:user, :username_no_letters)[:username]
      user.valid?
      expect(user.errors[:username]).to include("is invalid")
    end

    it "starts with a letter or number" do
      user.username = attributes_for(:user, :username_dash_start)[:username]
      user.valid?
      expect(user.errors[:username]).to include("is invalid")
    end

    it "ends with a letter or number" do
      user.username = attributes_for(:user, :username_dash_end)[:username]
      user.valid?
      expect(user.errors[:username]).to include("is invalid")
    end

    it "allows consecutive - and _" do
      user.username = attributes_for(:user, :username_double_special_chars)[:username]
      expect(user).to be_valid
    end

    it "is case-insensitive unique" do
      user.username = ctrl_user.username.upcase
      user.valid?
      expect(user.errors[:username]).to include("has already been taken")
    end
  end

  describe "#email" do
    it "is required" do
      blank_strings.each do |email|
        user.email = email
        user.valid?
        expect(user.errors[:email]).to include("can't be blank")
      end
    end

    it "has at most #{User::MAX_EMAIL_LEN} chars" do
      user.email = attributes_for(:user, :email_too_long)[:email]
      user.valid?
      expect(user.errors[:email]).to include(/is too long/)
    end

    it "has a username" do
      user.email = attributes_for(:user, :email_no_username)[:email]
      user.valid?
      expect(user.errors[:email]).to include("is invalid")
    end

    it "has an @ symbol" do
      user.email = attributes_for(:user, :email_no_at_symbol)[:email]
      user.valid?
      expect(user.errors[:email]).to include("is invalid")
    end

    it "has a domain name" do
      user.email = attributes_for(:user, :email_no_domain_name)[:email]
      user.valid?
      expect(user.errors[:email]).to include("is invalid")
    end

    it "has a top level domain" do
      user.email = attributes_for(:user, :email_no_top_level_domain)[:email]
      user.valid?
      expect(user.errors[:email]).to include("is invalid")
    end

    it "has no spaces" do
      user.email = attributes_for(:user, :email_with_spaces)[:email]
      user.valid?
      expect(user.errors[:email]).to include("is invalid")
    end

    it "is unique" do
      user.email = ctrl_user.email
      user.valid?
      expect(user.errors[:email]).to include("has already been taken")
    end
  end

  describe "#dob" do
    it "is latest #{User.max_dob} (#{User::MIN_USER_AGE} y.o)" do
      user.dob = attributes_for(:user, :dob_too_young)[:dob]
      user.valid?
      expect(user.errors[:dob]).to include("exceeded maximum date")
    end
  end

  describe "#password" do
    it "is required" do
      user.password = ' ' * User::MIN_PW_LEN
      user.valid?
      expect(user.errors[:password]).to include("can't be blank")
    end

    it "has at least #{User::MIN_PW_LEN} chars" do
      user.assign_attributes attributes_for(:user, :pw_too_short)
      user.valid?
      expect(user.errors[:password]).to include(/is too short/)
    end

    it "has at most #{User::MAX_PW_LEN} chars" do
      user.assign_attributes attributes_for(:user, :pw_too_long)
      user.valid?
      expect(user.errors[:password]).to include(/is too long/)
    end

    it "has at least 1 letter" do
      user.assign_attributes attributes_for(:user, :pw_no_letters)
      user.valid?
      expect(user.errors[:password]).to include("is invalid")
    end

    it "has at least 1 number" do
      user.assign_attributes attributes_for(:user, :pw_no_numbers)
      user.valid?
      expect(user.errors[:password]).to include("is invalid")
    end

    it "has at least 1 special char" do
      user.assign_attributes attributes_for(:user, :pw_no_special_chars)
      user.valid?
      expect(user.errors[:password]).to include("is invalid")
    end
  end

  describe "#password_confirmation" do
    it "is equal to password" do
      user.assign_attributes attributes_for(:user, :pw_not_equal_confirmation)
      user.valid?
      expect(user.errors[:password_confirmation]).to include("doesn't match Password")
    end
  end

  it "downcases email on validate" do
    user.email = attributes_for(:user, :email_uppercase)[:email]
    user.valid?
    expect(user.email).to eq(user.email.downcase)
  end

  it "converts DateTime to Date for dob" do
    user.dob = attributes_for(:user, :dob_datetime)[:dob]
    expect(user.dob.class).to eq(Date)
  end

  it "converts datetimestring to Date for dob" do
    user.dob = attributes_for(:user, :dob_datetime_str)[:dob]
    expect(user.dob.class).to eq(Date)
  end

  describe "#associations" do
    let(:global) { Community.find_by(name: 'global') }

    it "joins global community as regular member on create" do
      user = create :user
      membership = user.memberships.find_by(community: global)
      expect(membership.regular?).to be true
    end
  end
end
