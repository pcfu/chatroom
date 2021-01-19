FactoryBot.define do
  factory :user, aliases: [:base_user] do
    username { 'test_user-name' }
    email { 'test-user@chatroom.com' }
    password { 'abcdefg' }

    ### username traits ###

    trait :username_with_spaces do
      username { 't e s t u s e r' }
    end

    trait :username_only_underscores do
      username { '_____' }
    end

    trait :username_underscore_at_edges do
      username { '_test_user_' }
    end

    trait :username_double_special_chars do
      username { 'test_-user' }
    end

    trait :username_too_short do
      username { 'ab' }
    end

    trait :username_too_long do
      username { 'abcdefghijklmnop' }
    end

    ### email traits ###

    trait :email_no_username do
      email { '@chatroom.com' }
    end

    trait :email_no_at_symbol do
      email { 'test-user#chatroom.com' }
    end

    trait :email_no_domain_name do
      email { 'test-user@.com' }
    end

    trait :email_no_top_level_domain do
      email { 'test-user@chatroom'}
    end

    trait :email_with_spaces do
      email { 'test user@chatroom.com'}
    end
  end
end
