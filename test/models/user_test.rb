require 'test_helper'

class UserTest < ActiveSupport::TestCase

  setup do
    @user = build_stubbed(:user)
  end

  test "basic user is valid" do
    assert @user.valid?, 'basic user should be valid'
  end

  ### Test username ###

  test "username is not blank" do
    generate_blanks.each do |username|
      @user.username = username
      assert_not @user.valid?, 'blank username should be invalid'
    end
  end

  test "username has correct length" do
    %i(username_too_short username_too_long).each do |trait|
      @user = build_stubbed(:user, trait)
      assert_not @user.valid?, "username with incorrect length should be invalid"
    end
  end

  test "username has correct format" do
    traits = %i(username_with_spaces username_only_underscores
                username_underscore_at_edges username_double_special_chars)

    traits.each do |trait|
      @user = build_stubbed(:user, trait)
      assert_not @user.valid?, 'illegal username format should be invalid'
    end
  end

  ### Test email ###

  test "email is not blank" do
    generate_blanks.each do |email|
      @user.email = email
      assert_not @user.valid?, 'blank email should be invalid'
    end
  end

  test "email has correct format" do
    traits = FactoryBot.factories[:user].defined_traits
                       .select {|t| t.name.match? /\Aemail_(no|with)/}
                       .map {|t| t.name.to_sym}
    traits.each do |trait|
      @user = build_stubbed(:user, trait)
      assert_not @user.valid?, 'illegal email format should be invalid'
    end
  end

end
