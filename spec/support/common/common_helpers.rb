module CommonHelpers
  def blank_strings
    return [ nil, '', '     ' ]
  end

  def special_chars
    %q(!"#$%&'()*+,./:;<=>?@[\]^_`{|}~)
  end

  def icase_exact(string)
    /\A#{string}\z/i
  end

  def login_user
    create :user
    params = { session: attributes_for(:user).extract!(:username, :password) }
    post '/login', params: params
  end
end

RSpec.configure do |config|
  config.include CommonHelpers
end
