# frozen_string_literal: true

require 'application_system_test_case'

class UsersTest < ApplicationSystemTestCase
  setup do
    @alice = users(:alice)
    @carol = users(:carol)

    visit root_url
  end

  test 'アカウントを新規作成しログインする' do
    click_on 'アカウント登録', match: :first

    fill_in 'Eメール', with: 'bob@example.com'
    fill_in '氏名', with: 'Bob'
    fill_in '郵便番号', with: '1234567'
    fill_in '住所', with: 'Tokyo'
    fill_in '自己紹介文', with: '日本語勉強中です'
    fill_in 'パスワード', with: 'password'
    fill_in 'パスワード（確認用）', with: 'password'

    click_button 'アカウント登録'
    assert_text 'アカウント登録が完了しました。'
    assert_text 'Bob としてログイン中'
  end

  test '既存アカウントでログインする' do
    fill_in 'Eメール', with: 'alice@example.com'
    fill_in 'パスワード', with: 'password'
    click_button 'ログイン'
    assert_text 'ログインしました。'
  end

  test 'ログアウトする' do
    alice_login
    click_on 'ログアウト'

    assert_text 'ログアウトしました。'
    assert_selector 'h2', text: 'ログイン'
  end

  test 'ユーザの一覧ページを表示する' do
    alice_login
    visit users_url
    assert_selector 'h1', text: 'ユーザの一覧'
  end

  test 'アカウントの詳細ページを表示する' do
    alice_login
    visit users_url
    click_on 'このユーザを表示', match: :first

    assert_selector 'h1', text: 'ユーザの詳細'
  end

  test 'アカウントを編集しその詳細ページを表示する' do
    alice_login
    click_on 'アカウント編集', match: :first

    fill_in 'Eメール', with: "alice#{@alice.email}"
    fill_in '現在のパスワード', with: 'password'
    click_on '更新'

    assert_text 'アカウント情報を変更しました。'
    assert_text 'alicealice@example.com'
  end

  test 'アカウントを削除しログインページへ戻る' do
    alice_login
    click_on 'アカウント編集', match: :first
    page.accept_confirm do
      click_button 'アカウント削除'
    end

    assert_text 'アカウントを削除しました。またのご利用をお待ちしております。'
  end

  test 'ログイン中アカウントの詳細画面を表示し「このユーザを編集」リンクがあることを確認する' do
    alice_login
    visit user_url(@alice)

    assert_selector 'a', text: 'このユーザを編集'
  end

  test 'ログイン中アカウント以外の詳細画面を表示し「このユーザを編集」リンクがないことを確認する' do
    alice_login
    visit user_url(@carol)

    refute_selector 'a', text: 'このユーザを編集'
  end
end
