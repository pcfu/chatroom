require 'test_helper'

class UserTest < ActiveSupport::TestCase

  setup do
    User.delete_all
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
      assert_not @user.valid?, 'username with incorrect length should be invalid'
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

  test "username is unique" do
    @control = create(:control_user)
    assert @user.valid?, 'user with unique username should be valid'

    @user.username = @control.username
    assert_not @user.valid?, 'user with non-unique username should be invalid'
  end

  ### Test email ###

  test "email is not blank" do
    generate_blanks.each do |email|
      @user.email = email
      assert_not @user.valid?, 'blank email should be invalid'
    end
  end

  test "email has correct length" do
    @user = build_stubbed(:user, :email_too_long)
    assert_not @user.valid?, 'email that is too long should be invalid'
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

  test "email is unique" do
    @control = create(:control_user)
    assert @user.valid?, 'user with unique email should be valid'

    @user.email = @control.email
    assert_not @user.valid?, 'user with non-unique email should be invalid'
  end

  test "email is downcased before save" do
    @user = build(:user, :email_uppercase)
    email = @user.email
    @user.save
    assert_equal email.downcase, @user.email, 'email should be downcased before save'
  end

  ### Test password ###

  test "password is not blank" do
    @user.password = ' ' * 8
    @user.password_confirmation = ' ' * 8
    assert_not @user.valid?, 'blank password should be invalid'
  end

  test "password is different from confirmation password" do
    @user = build_stubbed(:user, :pw_not_equal_confirmation)
    assert_not @user.valid?, 'password and confirmation password should be equal'
  end

  test "password has correct length" do
    @user = build_stubbed(:user, :pw_too_short)
    assert_not @user.valid?, 'password less than 8 characters should be invalid'

    @user = build_stubbed(:user, :pw_too_long)
    assert_not @user.valid?, 'password more than 30 characters should be invalid'
  end

  test "password has at least one letter digit and special character" do
    @user = build_stubbed(:user, :pw_no_letters)
    assert_not @user.valid?, 'password with no letters should be invalid'

    @user = build_stubbed(:user, :pw_no_digits)
    assert_not @user.valid?, 'password with no digits should be invalid'

    @user = build_stubbed(:user, :pw_no_special_chars)
    assert_not @user.valid?, 'password with no special characters should be invalid'
  end

  ### Test D.O.B ###

  test "DOB is not blank" do
    @user.dob = nil
    assert_not @user.valid?, 'blank date of birth should be invalid'
  end

end
