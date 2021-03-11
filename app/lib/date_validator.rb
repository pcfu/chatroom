class DateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    check_options
    return if value.nil?

    if !value.is_a? Date
      return record.errors.add attribute, (options[:message] || "is not a date")
    end

    if options.has_key?(:min) && value < options[:min].to_date
      return record.errors.add attribute, (options[:message] || "exceeded minimum date")
    end

    if options.has_key?(:max) && value > options[:max].to_date
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
          "#{options[key].inspect} is not a valid #{key}_date for date validation"
        ) if options.has_key?(key) && !is_valid_date(options[key])
      end

      if options.has_key?(:min) && options.has_key?(:max)
        raise ArgumentError.new(
          ":min must be <= :max for date validation"
        ) if options[:min].to_date > options[:max].to_date
      end
    end

    def is_valid_date(date)
      return date.is_a?(Date) || date.is_a?(DateTime) || is_valid_datestr(date)
    end

    def is_valid_datestr(str)
      return false unless str.is_a? String
      return false unless str.match? /\A\d{4}.\d{2}.\d{2}/

      begin
        str.to_date
      rescue Date::Error
        return false
      end
      true
    end
end
