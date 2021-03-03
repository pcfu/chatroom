require 'test_helper'

module DateValidatables
  class BaseDateValidatable
    include ActiveModel::Validations
    attr_accessor :date
  end

  class DateValidatable < BaseDateValidatable
    validates :date, date: true
  end

  class LegalOptionsDateValidatable < BaseDateValidatable
    MIN_DATE = Date.current.advance(years: -100)
    MAX_DATE = Globals::App::MAX_DOB
    MESSAGE = "is invalid"
    validates :date, date: { min: MIN_DATE, max: MAX_DATE, message: MESSAGE }
  end

  class DateTimeMinDateValidatable < BaseDateValidatable
    MIN_DATE = Date.current
    validates :date, date: { min: MIN_DATE.to_datetime }
  end

  class DateStringMinDateValidatable < BaseDateValidatable
    MIN_DATE = Date.current
    validates :date, date: { min: MIN_DATE.to_datetime.to_s }
  end

  class DateTimeMaxDateValidatable < BaseDateValidatable
    MAX_DATE = Date.current
    validates :date, date: { max: MAX_DATE }
  end

  class DateStringMaxDateValidatable < BaseDateValidatable
    MAX_DATE = Date.current
    validates :date, date: { max: MAX_DATE.to_datetime.to_s }
  end

  class IllegalOptionsDateValidatable < BaseDateValidatable
    validates :date, date: { option: 'unknown' }
  end

  class InvalidMinDateValidatable < BaseDateValidatable
    validates :date, date: { min: 'not a date' }
  end

  class InvalidMaxDateValidatable < BaseDateValidatable
    validates :date, date: { max: 'not a date' }
  end

  class MinMoreThanMaxDateValidatable < BaseDateValidatable
    validates :date, date: { min: Globals::App::MAX_DOB + 1,
                             max: Globals::App::MAX_DOB }
  end
end

class DateValidatorTest < ActiveSupport::TestCase
  include DateValidatables

  test "function is_valid_date(date) identifies dates correctly" do
    validator = DateValidator.new({attributes: :dummy})

    [Date.current, DateTime.current, DateTime.current.to_s].each do |date|
      assert validator.send(:is_valid_date, date), "rejected valid dates"
    end

    [1, "not a date", "2020/01"].each do |non_date|
      assert_not validator.send(:is_valid_date, non_date), "accepted non-dates"
    end
  end

  test "validate object with basic date validation does not raise exception" do
    @obj = DateValidatable.new
    @obj.date = Globals::App::MAX_DOB
    assert @obj.valid?, "should validate without exceptions"
  end

  test "validate object with legal options does not raise exception" do
    @obj = LegalOptionsDateValidatable.new
    @obj.date = LegalOptionsDateValidatable::MAX_DATE
    assert @obj.valid?, "should validate without exceptions"
  end

  test "validate object with min date as DateTime does not raise exception" do
    @obj = DateTimeMinDateValidatable.new
    @obj.date = DateTimeMinDateValidatable::MIN_DATE
    assert @obj.valid?, "should validate without exceptions"
  end

  test "validate object with min date as date string does not raise exception" do
    @obj = DateStringMinDateValidatable.new
    @obj.date = DateStringMinDateValidatable::MIN_DATE
    assert @obj.valid?, "should validate without exceptions"
  end

  test "validate object with max date as DateTime does not raise exception" do
    @obj = DateTimeMaxDateValidatable.new
    @obj.date = DateTimeMaxDateValidatable::MAX_DATE
    assert @obj.valid?, "should validate without exceptions"
  end

  test "validate object with max date as date string does not raise exception" do
    @obj = DateStringMaxDateValidatable.new
    @obj.date = DateStringMaxDateValidatable::MAX_DATE
    assert @obj.valid?, "should validate without exceptions"
  end

  test "validate object with illegal options raises argument error" do
    @obj = IllegalOptionsDateValidatable.new
    e = assert_raise(ArgumentError) { @obj.valid? }
    assert_match /\AInvalid option .+ for date validation\z/, e.message
  end

  test "validate object with invalid min date raises argument error" do
    @obj = InvalidMinDateValidatable.new
    e = assert_raise(ArgumentError) { @obj.valid? }
    assert_match /\A.+ is not a valid date for date validation\z/, e.message
  end

  test "validate object with invalid max date raises argument error" do
    @obj = InvalidMaxDateValidatable.new
    e = assert_raise(ArgumentError) { @obj.valid? }
    assert_match /\A.+ is not a valid date for date validation\z/, e.message
  end

  test "validate object with min date greater than max date raises argument error" do
    @obj = MinMoreThanMaxDateValidatable.new
    e = assert_raise(ArgumentError) { @obj.valid? }
    assert_match ":min must be <= :max for date validation", e.message
  end

  test "date validation with blank date does not invalidate object" do
    @obj = DateValidatable.new
    @obj.date = nil
    assert @obj.valid?, "object should be valid"
  end

  test "date validation with min date exceeded invalidates object" do
    @obj = LegalOptionsDateValidatable.new
    @obj.date = LegalOptionsDateValidatable::MIN_DATE - 1
    assert_not @obj.valid?, "object should be invalid"
  end

  test "date validation with max date exceeded invalidates object" do
    @obj = LegalOptionsDateValidatable.new
    @obj.date = LegalOptionsDateValidatable::MAX_DATE + 1
    assert_not @obj.valid?, "object should be invalid"
  end

  test "print specified message on validation error" do
    @obj = LegalOptionsDateValidatable.new
    @obj.date = LegalOptionsDateValidatable::MAX_DATE + 1
    @obj.validate
    assert_match /\A.+ is invalid\z/, @obj.errors.full_messages.first,
                 "did not print specified message"
  end
end
