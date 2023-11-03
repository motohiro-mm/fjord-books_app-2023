# frozen_string_literal: true

require 'application_system_test_case'

class ReportsTest < ApplicationSystemTestCase
  setup do
    @alice_report = reports(:alice_report)
    @carol_report = reports(:carol_report)

    visit root_url
    alice_login
  end

  test '日報の一覧ページを表示する' do
    visit reports_url
    assert_selector 'h1', text: '日報の一覧'
  end

  test '日報の詳細ページを表示する' do
    visit reports_url
    click_on 'この日報を表示', match: :first

    assert_selector 'h1', text: '日報の詳細'
  end

  test '日報を新規作成しその詳細ページを表示する' do
    visit reports_url
    click_on '日報の新規作成'

    fill_in 'タイトル', with: 'AliceReport2'
    fill_in '内容', with: 'I am full.'
    click_on '登録する'

    assert_text '日報が作成されました'
    assert_text 'AliceReport2'
    assert_text 'I am full.'
  end

  test '日報を編集しその詳細ページを表示する' do
    visit report_url(@alice_report)
    click_on 'この日報を編集', match: :first

    fill_in 'タイトル', with: "#{@alice_report.title} ver.2"
    fill_in '内容', with: "#{@alice_report.content} Now!"
    click_on '更新する'

    assert_text '日報が更新されました'
    assert_text 'AliceReport ver.2'
    assert_text 'I am hungry! Now!'
  end

  test '日報を削除し一覧ページへ戻る' do
    visit report_url(@alice_report)
    click_on 'この日報を削除', match: :first

    assert_text '日報が削除されました。'
    assert_selector 'h1', text: '日報の一覧'
    refute_text 'AliceReport'
    refute_text 'I am hungry!'
  end

  test 'ログイン中アカウントの作成した日報の詳細画面を表示し「この日報を編集」リンクがあることを確認する' do
    visit report_url(@alice_report)

    assert_selector 'a', text: 'この日報を編集'
  end

  test 'ログイン中アカウント以外で作成された日報の詳細画面を表示し「この日報を編集」リンクがないことを確認する' do
    visit report_url(@carol_report)

    refute_selector 'a', text: 'この日報を編集'
  end
end
