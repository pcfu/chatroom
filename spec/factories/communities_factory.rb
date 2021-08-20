FactoryBot.define do
  factory :community, aliases: [:minimum_community] do
    name        { "Test Community" }
    description { "Minimum valid community" }
    handle      { "TEST" }

    factory :control_community do
      name        { "Control Community" }
      description { "Control community for testing purposes" }
      handle      { "CTRL" }
      access      { "private" }
    end

    ### name traits

    trait :name_too_short do
      name { 'a' * (Community::MIN_CNAME_LEN - 1) }
    end

    trait :name_too_long do
      name { 'a' * (Community::MAX_CNAME_LEN + 1) }
    end

    ### description traits

    trait :desc_too_long do
      description { 'a' * (Community::MAX_DESC_LEN + 1) }
    end

    ### handle traits

    trait :handle_too_short do
      handle { "T" }
    end

    trait :handle_too_long do
      handle { "TESTS" }
    end

    trait :handle_with_numbers do
      handle { "T35T" }
    end

    trait :handle_lowercase do
      handle { "test" }
    end
  end
end
