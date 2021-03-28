FactoryBot.define do
  factory :user, aliases: [:base_user] do
    username { 'test_user-name' }
    email { 'test-user@chatroom.com' }
    dob { User.max_dob }
    password { 'P@ssw5rd' }
    password_confirmation { 'P@ssw5rd' }

    factory :control_user do
      username { 'ctrl_user-name' }
      email { 'control-user@chatroom.com' }
    end

    ### username traits ###

    trait :username_too_short do
      username { 'a' * (User::MIN_UNAME_LEN - 1) }
    end

    trait :username_too_long do
      username { 'a' * (User::MAX_UNAME_LEN + 1) }
    end

    trait :username_with_spaces do
      username { 't e s t u s e r' }
    end

    trait :username_no_letters do
      username { '_____' }
    end

    trait :username_dash_start do
      username { '-test-user' }
    end

    trait :username_dash_end do
      username { 'test-user-' }
    end

    trait :username_double_special_chars do
      username { 'test_-user' }
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

    ### d.o.b traits ###

    trait :dob_too_young do
      dob { User.max_dob.advance(days: 1) }
    end

    trait :dob_datetime do
      dob { User.max_dob.to_datetime }
    end

    trait :dob_datetime_str do
      dob { User.max_dob.to_datetime.to_s }
    end

    ### password traits ###

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

    trait :pw_no_numbers do
      password { 'P@ssword' }
      password_confirmation { 'P@ssword' }
    end

    trait :pw_no_special_chars do
      password { 'Passw0rd' }
      password_confirmation { 'Passw0rd' }
    end

    trait :pw_not_equal_confirmation do
      password_confirmation { 'P@55w0rd' }
    end
  end
end
