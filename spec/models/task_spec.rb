require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validation' do
    let(:user) { create(:user) }
    let!(:task) { create(:task, user: user) }

    it '全ての属性が有効' do
      expect(task).to be_valid
    end

    it 'タイトル空白で無効' do
      task.title = nil
      task.valid?
      expect(task.errors[:title]).to include("can't be blank")
    end

    it 'ステータス空白で無効' do
      task.status = nil
      task.valid?
      expect(task.errors[:status]).to include("can't be blank")
    end

    it 'タイトル重複で無効' do
      duplication = Task.create(title: 'テストタイトル', status: 0, user: user)
      duplication.valid?
      expect(duplication.valid?).to eq(false)
    end

    it 'タイトルユニークで有効' do
      unique = Task.create(title: 'ユニークタイトル', status: 0, user: user)
      expect(unique).to be_valid
    end
  end
end
