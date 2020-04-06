require 'rails_helper'

RSpec.describe Task, type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let!(:task) { create(:task, user: user) }

  describe '掲示板のCRUD機能' do
    describe 'ログイン前' do
      context '掲示板作成ページへアクセス' do
        it '掲示板作成が失敗(ログインページへリダイレクト)' do
          visit new_task_path
          expect(current_path).to eq login_path
          expect(page).to have_content 'Login required'
        end
      end
      context '掲示板編集ページへアクセス' do
        it '掲示板編集が失敗(ログインページへリダイレクト)' do
          visit edit_task_path(task)
          expect(current_path).to eq login_path
          expect(page).to have_content 'Login required'
        end
      end
    end

    describe 'ログイン後' do
      before do
        login(user)
      end
      context '掲示板作成ページへアクセス' do
        it '掲示板作成が成功' do
          visit new_task_path
          fill_in 'Title', with: 'テストタイトル'
          click_button 'Create Task'
          # expect(current_path).to eq task_path(task)
          expect(page).to have_content 'Task was successfully created.'
          expect(page).to have_content 'テストタイトル'
        end
      end
      context '掲示板編集ページへアクセス' do
        it '掲示板編集が成功' do
          visit edit_task_path(task)
          fill_in 'Title', with: 'タスクを編集'
          click_button 'Update Task'
          expect(current_path).to eq task_path(task)
          expect(page).to have_content 'Task was successfully updated.'
          expect(page).to have_content 'タスクを編集'
        end
      end
      context '掲示板削除パスへアクセス' do
        it '掲示板削除が成功' do
          visit tasks_path
          # data属性の指定
          accept_confirm { click_link 'Destroy' }
          expect(current_path).to eq tasks_path
          expect(page).to have_content 'Task was successfully destroyed.'
          # have_no_contentでtask.titleがないことを確認
          expect(page).to have_no_content task.title
        end
      end
    end
  end
  describe '他ユーザーのタスク編集ページにアクセス' do
    before do
      login(other_user)
    end
    it 'アクセスが失敗' do
      visit edit_task_path(task)
      expect(current_path).to eq root_path
      expect(page).to have_content 'Forbidden access.'
    end
  end
end