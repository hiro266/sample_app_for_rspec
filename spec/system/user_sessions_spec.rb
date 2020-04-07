require 'rails_helper'

RSpec.describe 'UserSession', type: :system do
  let(:user) { create(:user) }

  describe 'ユーザー認証機能' do
    describe 'ログイン前' do
      context 'フォームの入力値が正常' do
        it 'ログインが成功' do
          login(user)
          expect(current_path).to eq root_path
          expect(page).to have_content 'Login successful'
        end
      end
      context 'フォームが未入力' do
        it 'ログインが失敗' do
          visit login_path
          fill_in 'Email', with: nil
          fill_in 'Password', with: nil
          click_button 'Login'
          expect(current_path).to eq login_path
          expect(page).to have_content 'Login failed'
        end
      end
    end
    describe 'ログイン後' do
      context 'ログアウトボタンをクリック' do
        it 'ログアウト処理が成功する' do
          login(user)
          visit tasks_path
          click_link 'Logout'
          expect(current_path).to eq root_path
          expect(page).to have_content 'Logged out'
        end
      end
    end
  end
end