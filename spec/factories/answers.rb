FactoryBot.define do
  factory :answer do
    body

    trait :invalid do
      body { nil }
    end
  end
end
