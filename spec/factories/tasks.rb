FactoryBot.define do
  factory :task do
    title { 'テストタイトル' }
    status { :todo }
    user
  end
end
