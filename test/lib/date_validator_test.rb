require 'test_helper'

module DateValidatables
  class BaseDateValidatable
    include ActiveModel::Validations
    attr_accessor :date
  end

  class DateValidatable < BaseDateValidatable
    validates :date, date: true
  end

  class IllegalOptionDateValidatable < BaseDateValidatable
    validates :date, date: { option: 'unknown' }
  end
end

class DateValidatorTest < ActiveSupport::TestCase
  include DateValidatables

  test "basic date validation does not raise exception" do
    @obj = DateValidatable.new
    @obj.date = Globals::App::MAX_DOB
    assert @obj.valid?
  end

  test "validate object with illegal options" do
    @obj = IllegalOptionDateValidatable.new
    @obj.date = Globals::App::MAX_DOB

    e = assert_raise(ArgumentError) { @obj.valid? }
    assert_match /\AInvalid option .+ for date validation\z/, e.message
  end

  test "date validate with blank date does not invalidate object" do
    @obj = DateValidatable.new
    @obj.date = nil
    assert @obj.valid?, "object should be valid"
  end

end
