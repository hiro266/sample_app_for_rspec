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
      expect(task).to be_invalid include("can't be blank")
    end

    it 'ステータス空白で無効' do
      task.status = nil
      expect(task).to be_invalid include("can't be blank")
    end

    it 'タイトル重複で無効' do
      task_with_duplication_title = build(:task, title: 'テストタイトル4', status: :todo)
      expect(task_with_duplication_title.valid?).to eq(false)
    end

    it 'タイトルユニークで有効' do
      task_with_unique_title = build(:task, title: 'ユニークタイトル', status: :todo)
      expect(task_with_unique_title).to be_valid
    end
  end
end
