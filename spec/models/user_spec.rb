require 'rails_helper'

RSpec.describe User, type: :model do

  before(:all) do
    @user = build_stubbed(:user)
  end

  it "is valid with valid attributes" do
    expect(@user).to be_valid
  end

  ### Test username ###

  it "is invalid with blank username" do
    generate_blanks.each do |username|
      @user.username = username
      expect(@user).not_to be_valid
    end
  end
end
