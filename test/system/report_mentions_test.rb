# frozen_string_literal: true

require 'application_system_test_case'

class ReportMentionsTest < ApplicationSystemTestCase
  setup do
    @alice_report = reports(:alice_report)
    @carol_report = reports(:carol_report)
    @alice_report_mentioning_carol_report = reports(:alice_report_mentioning_carol_report)
    @alice_report_mentioning_carol_report.update!(content: "I want to have lunch with you! http://localhost:3000/reports/#{@carol_report.id}")

    visit root_url
    alice_login
  end

  test 'メンションされていない日報は「（この日報に言及している日報はまだありません）」と表示する' do
    visit report_url(@alice_report_mentioning_carol_report)
    within '.mentions-container' do
      assert_text '（この日報に言及している日報はまだありません）'
    end
  end

  test 'メンション先の日報はメンション元日報のタイトル、ユーザ名を表示する' do
    visit report_url(@carol_report)

    within '.mentions-container' do
      assert_text 'Mention to CarolReport'
      assert_text 'Alice'
    end
  end

  test 'メンションを含んだ日報を新規作成しメンション先にメンションを表示する' do
    visit reports_url
    click_on '日報の新規作成'

    fill_in 'タイトル', with: 'Mention to AliceReport'
    fill_in '内容', with: "I am never full! http://localhost:3000/reports/#{@alice_report.id}"
    click_on '登録する'
    assert_text '日報が作成されました'

    visit report_url(@alice_report)
    within '.mentions-container' do
      assert_text 'Mention to AliceReport'
      assert_text 'Alice'
    end
  end

  test 'メンションを含んだ日報を削除するとメンション先の日報詳細ページからメンションの表示がなくなる' do
    visit report_url(@alice_report_mentioning_carol_report)
    click_on 'この日報を削除', match: :first

    assert_text '日報が削除されました。'

    visit report_url(@carol_report)

    within '.mentions-container' do
      assert_text '（この日報に言及している日報はまだありません）'
    end
  end
end
