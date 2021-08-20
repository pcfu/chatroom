module ModelSpecHelpers
  def blank_strings
    return [ nil, '', '     ' ]
  end

  def special_chars
    %q(!"#$%&'()*+,./:;<=>?@[\]^_`{|}~)
  end
end

RSpec.configure do |config|
  config.include ModelSpecHelpers
end
