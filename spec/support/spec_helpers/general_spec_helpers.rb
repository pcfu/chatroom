module GeneralSpecHelpers
  def icase_exact(string)
    /\A#{string}\z/i
  end

  def login_user
    create :user
    params = { session: attributes_for(:user).extract!(:username, :password) }
    post '/login', params: params
  end

  def gui_login_user(user)
    visit '/login'
    fill_in 'session_username', with: user.username
    fill_in 'session_password', with: user.password
    find(".btn[value=login]").click
    sleep 0.1
  end
end

RSpec.configure do |config|
  config.include GeneralSpecHelpers
end
