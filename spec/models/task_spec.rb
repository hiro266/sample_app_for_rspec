require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validation' do
    let(:user) { create(:user) }
    let!(:task) { create(:task) }

    it '全ての属性が有効' do
      expect(task).to be_valid
    end

    it 'タイトル空白で無効' do
      task.title = nil
      expect(task).to be_invalid
    end

    it 'ステータス空白で無効' do
      task.status = nil
      expect(task).to be_invalid
    end

    it 'タイトル重複で無効' do
      task_with_duplication_title = build(:task, title: 'テストタイトル', status: 0)
      expect(task_with_duplication_title.valid?).to eq(false)
    end

    it 'タイトルユニークで有効' do
      task_with_unique_title = build(:task, title: 'ユニークタイトル', status: 0)
      expect(task_with_unique_title).to be_valid
    end
  end
end
