FactoryBot.define do

  factory :user, aliases: [:base_user] do
    username { 'test_user' }
    email { 'testuser@chatroom.com' }
    password { 'abcdefg' }
  end

end
