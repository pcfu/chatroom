module CommonHelpers
  def generate_blanks(type: String, include_nil: true)
    blanks = include_nil ? [ nil ] : [ ]
    blanks += [ '', '     ' ] if type == String
    return blanks
  end
end

RSpec.configure do |config|
  config.include CommonHelpers
end
