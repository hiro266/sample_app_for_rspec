FactoryBot.define do
  factory :task do
    title { 'テストタイトル' }
    status { 0 }
    user
  end
end
