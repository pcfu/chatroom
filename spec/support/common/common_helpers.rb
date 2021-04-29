module CommonHelpers
  def generate_blanks(type: String, include_nil: true)
    blanks = include_nil ? [ nil ] : [ ]
    blanks += [ '', '     ' ] if type == String
    return blanks
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
