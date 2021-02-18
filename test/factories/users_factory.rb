FactoryBot.define do
  factory :user, aliases: [:base_user] do
    username { 'test_user-name' }
    email { 'test-user@chatroom.com' }
    password { 'P@ssw5rd' }
    password_confirmation { 'P@ssw5rd' }

    factory :control_user do
      username { 'ctrl_user-name' }
      email { 'control-user@chatroom.com' }
    end

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

    trait :email_too_long do
      email { "#{'a' * 243}@chatroom.com"}
    end

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

    trait :email_uppercase do
      email { 'TEST_USER@chatroom.com' }
    end

    ### password traits ###

    trait :pw_not_equal_confirmation do
      password_confirmation { 'P@55w0rd' }
    end

    trait :pw_too_short do
      password { 'P@ssw0r' }
      password_confirmation { 'P@ssw0r' }
    end

    trait :pw_too_long do
      password { 'P@ssw0rd' + 'a' * 23 }
      password_confirmation { 'P@ssw0rd' + 'a' * 23 }
    end

    trait :pw_no_letters do
      password { '1111111@' }
      password_confirmation { '1111111@' }
    end

    trait :pw_no_digits do
      password { 'P@ssword' }
      password_confirmation { 'P@ssword' }
    end

    trait :pw_no_special_chars do
      password { 'Passw0rd' }
      password_confirmation { 'Passw0rd' }
    end

  end
end
