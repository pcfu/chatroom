FactoryBot.define do
  factory :channel, aliases: [:base_channel] do
    name        { 'main' }

    factory :control_channel do
      name        { 'secondary' }
      description { "Example description for a channel" }
    end

    ### name traits

    trait :name_too_short do
      name { 'a' * (Channel::MIN_NAME_LEN - 1) }
    end

    trait :name_too_long do
      name { 'a' * (Channel::MAX_NAME_LEN + 1) }
    end

    trait :name_with_spaces do
      name { 'main channel' }
    end

    trait :name_with_dashes do
      name { 'main-channel' }
    end

    trait :name_dash_start do
      name { '-main' }
    end

    trait :name_dash_end do
      name { 'main-' }
    end

    trait :name_consecutive_dashes do
      name { 'main--channel' }
    end

    trait :name_uppercase do
      name { 'MAIN' }
    end

    ### description traits

    trait :desc_too_long do
      description { 'a' * (Channel::MAX_DESC_LEN + 1) }
    end

  end
end
