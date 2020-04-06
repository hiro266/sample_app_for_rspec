require 'rails_helper'

RSpec.describe User, type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let!(:task) { create(:task, user: user) }

# ログイン前の処理
  describe 'ログイン前' do
    describe 'ユーザー新規登録' do
      context 'フォームの入力値が正常' do
        it 'ユーザーの新規作成が成功' do
          visit sign_up_path
          fill_in 'Email', with: 'test@example.com'
          fill_in 'Password', with: 'password'
          fill_in 'Password confirmation', with: 'password'
          click_button 'SignUp'
          # login_pathへ遷移することを期待する
          expect(current_path).to eq login_path
          # 遷移されたページに'User was successfully created.'の文字列があることを期待する
          expect(page).to have_content 'User was successfully created.'
        end
      end
      context 'メールアドレスが未入力' do
        it 'ユーザーの新規作成が失敗' do
          visit sign_up_path
          fill_in 'Email', with: nil
          fill_in 'Password', with: 'password'
          fill_in 'Password confirmation', with: 'password'
          click_button 'SignUp'
          expect(current_path).to eq users_path
          expect(page).to have_content "Email can't be blank"
        end
      end
      context '登録済メールアドレスを使用' do
        it 'ユーザーの新規作成が失敗する' do
          visit sign_up_path
          fill_in 'Email', with: user.email
          fill_in 'Password', with: 'password'
          fill_in 'Password confirmation', with: 'password'
          click_button 'SignUp'
          expect(current_path).to eq users_path
          expect(page).to have_content "Email has already been taken"
        end
      end
    end
    describe 'マイページ' do
      it 'マイページへのアクセスが失敗' do
        visit user_path(user)
        expect(current_path).to eq login_path
        expect(page).to have_content 'Login required'
      end
    end
  end

# ログイン後の処理
  describe 'ログイン後' do
    before do
      login(user)
    end
    describe 'ユーザー編集' do
      context 'フォームの入力値が正常' do
        it 'ユーザーの編集が成功' do
          visit edit_user_path(user)
          fill_in 'Email', with: 'test@example.com'
          fill_in 'Password', with: 'test'
          fill_in 'Password confirmation', with: 'test'
          click_button 'Update'
          expect(current_path).to eq user_path(user)
          expect(page).to have_content 'User was successfully updated.'
        end
      end
      context 'メールアドレスが未入力' do
        it 'ユーザーの編集が失敗' do
          visit edit_user_path(user)
          fill_in 'Email', with: nil
          fill_in 'Password', with: 'password'
          fill_in 'Password confirmation', with: 'password'
          click_button 'Update'
          expect(current_path).to eq user_path(user)
          expect(page).to have_content "Email can't be blank"
        end
      end
      context '他ユーザーのユーザー編集ページにアクセス' do
        it 'アクセスが失敗' do
          # let(:other_user)が呼び出されログインユーザーのページへアクセス
          visit edit_user_path(other_user)
          expect(current_path).to eq user_path(user)
          expect(page).to have_content 'Forbidden access.'
        end
      end
    end
  end

  describe 'マイページ' do
    before do
      login(user)
    end
    context 'タスクを作成' do
      it '新規作成したタスクが表示される' do
        visit user_path(user)
        expect(page).to have_content 'テストタイトル'
      end
    end
  end
end