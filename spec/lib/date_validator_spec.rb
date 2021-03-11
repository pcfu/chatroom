require 'rails_helper'

class DateValidatable
  include ActiveModel::Validations

  MIN_DATE = Date.current.advance(years: -100)
  MAX_DATE = Date.current
  MIN_MAX_OPTIONS = { min: MIN_DATE, max: MAX_DATE }
  FULL_OPTIONS = MIN_MAX_OPTIONS.merge({message: 'is invalid' })

  attr_accessor :date
  validates :date, date: true

  def initialize(options = {})
    set_validation_options(options)
  end

  def set_validation_options(options)
    _validators[:date].first.instance_variable_set(:@options, options)
  end
end


RSpec.describe DateValidator do
  subject(:validatable) { DateValidatable.new(defined?(options) ? options : {}) }
  let(:invalid_date) { 'not a date' }

  it { is_expected.to be_valid }

  context "when legal options" do
    it "accepts min, max, and message options" do
      validatable.set_validation_options(DateValidatable::FULL_OPTIONS)
      expect(validatable).to be_valid
    end

    it "accepts min date as DateTime" do
      validatable.set_validation_options({ min: DateValidatable::MIN_DATE.to_datetime })
      expect(validatable).to be_valid
    end

    it "accepts min date as datetimestring" do
      validatable.set_validation_options({ min: DateValidatable::MIN_DATE.to_datetime.to_s })
      expect(validatable).to be_valid
    end

    it "accepts max date as DateTime" do
      validatable.set_validation_options({ max: DateValidatable::MAX_DATE.to_datetime })
      expect(validatable).to be_valid
    end

    it "accepts max date as datetimestring" do
      validatable.set_validation_options({ max: DateValidatable::MAX_DATE.to_datetime.to_s })
      expect(validatable).to be_valid
    end
  end

  context "when illegal options" do
    it "prints correct msg with invalid option" do
      validatable.set_validation_options({ option: 'unknown' })
      expect { validatable.valid? }.to raise_error(ArgumentError, /Invalid option :option/)
    end

    it "prints correct msg with invalid min date" do
      validatable.set_validation_options({ min: invalid_date })
      expect { validatable.valid? }.to raise_error(
        ArgumentError, /"#{invalid_date}" is not a valid min_date/
      )
    end

    it "prints correct msg with invalid max date" do
      validatable.set_validation_options({ max: invalid_date })
      expect { validatable.valid? }.to raise_error(
        ArgumentError, /"#{invalid_date}" is not a valid max_date/
      )
    end

    it "prints correct msg with min_date > max_date" do
      validatable.set_validation_options({ min: Date.current + 1, max: Date.current })
      expect { validatable.valid? }.to raise_error(ArgumentError, /:min must be <= :max/)
    end
  end

  context "when field is invalid" do
    let(:options) { DateValidatable::MIN_MAX_OPTIONS }

    it "adds correct error for non-date field" do
      validatable.date = invalid_date
      validatable.valid?
      expect(validatable.errors[:date]).to include("is not a date")
    end

    it "adds correct error for date before min_date" do
      validatable.date = DateValidatable::MIN_DATE - 1
      validatable.valid?
      expect(validatable.errors[:date]).to include("exceeded minimum date")
    end

    it "adds correct error for date after max_date" do
      validatable.date = DateValidatable::MAX_DATE + 1
      validatable.valid?
      expect(validatable.errors[:date]).to include("exceeded maximum date")
    end

    it "adds correct error using specified message" do
      validatable.set_validation_options(DateValidatable::FULL_OPTIONS)
      validatable.date = DateValidatable::MAX_DATE + 1
      validatable.valid?
      expect(validatable.errors[:date]).to include("is invalid")
    end
  end

  context "when field is valid" do
    let(:options) { DateValidatable::MIN_MAX_OPTIONS }

    it "has no error for date >= min_date" do
      validatable.date = DateValidatable::MIN_DATE
      expect(validatable).to be_valid
    end

    it "has no error for date <= max_date" do
      validatable.date = DateValidatable::MAX_DATE
      expect(validatable).to be_valid
    end
  end
end
