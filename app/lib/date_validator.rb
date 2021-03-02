class DateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    check_options
    return if value.nil?

    if !value.is_a? Date
      return record.errors.add attribute, (options[:message] || "is not a date")
    end

    if options.has_key?(:min) && value < options[:min]
      return record.errors.add attribute, (options[:message] || "exceeded minimum date")
    end

    if options.has_key?(:max) && value > options[:max]
      return record.errors.add attribute, (options[:message] || "exceeded maximum date")
    end
  end

  private

    def check_options
      illegal_opts = options.keys.without(:min, :max, :message)
      raise ArgumentError.new(
        "Invalid option :#{illegal_opts.first} for date validation"
      ) if illegal_opts.present?

      [:min, :max].each do |key|
        raise ArgumentError.new(
          "#{options[key]} is not a valid date for date validation"
        ) if options.has_key?(key) && !is_valid_date(options[key])
      end

      if options.has_key?(:min) && options.has_key?(:max)
        raise ArgumentError.new(
          ":min must be <= :max for date validation"
        ) if options[:min] > options[:max]
      end
    end

    def is_valid_date(date)
      return date.is_a?(Date) || date.is_a?(DateTime) || is_valid_datestr(date)
    end

    def is_valid_datestr(str)
      return false unless str.is_a? String
      begin
        str.to_date
      rescue Date::Error
        return false
      end
      true
    end
end
