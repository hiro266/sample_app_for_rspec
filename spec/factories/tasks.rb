FactoryBot.define do
  factory :task do
    sequence(:title) { |n| "テストタイトル#{n}" }
    status { :todo }
    user
  end
end
