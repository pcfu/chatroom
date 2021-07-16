FactoryBot.define do
  factory :community, aliases: [:base_community] do
    name        { "test community" }
    description { "minimum valid community" }

    factory :control_community do
      name        { "control community" }
      description { "control community for testing purposes" }
    end

    ### name traits

    trait :name_too_short do
      name { 'a' * (Community::MIN_CNAME_LEN - 1) }
    end

    trait :name_too_long do
      name { 'a' * (Community::MAX_CNAME_LEN + 1) }
    end

    trait :name_uppercase do
      name { 'TEST COMMUNITY' }
    end

    ### description traits

    trait :desc_too_long do
      description { 'a' * (Community::MAX_DESC_LEN + 1) }
    end
  end
end
