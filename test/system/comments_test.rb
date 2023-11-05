# frozen_string_literal: true

require 'application_system_test_case'

class CommentsTest < ApplicationSystemTestCase
  setup do
    @cherry_book = books(:cherry_book)
    @erd_lesson = books(:erd_lesson)
    @alice_report = reports(:alice_report)
    @carol_report = reports(:carol_report)

    visit root_url
    alice_login
  end

  test 'コメントがない場合は「(コメントはまだありません)」と表示する' do
    visit book_url(@erd_lesson)
    within '.comments-container' do
      assert_text '(コメントはまだありません)'
    end
  end

  test '本へのコメントを新規作成する' do
    visit book_url(@cherry_book)

    fill_in 'comment_content', with: 'Thanks to this book, I was able to love Ruby!'
    click_button 'コメントする'

    assert_text 'コメントが作成されました'
    assert_text 'Thanks to this book, I was able to love Ruby!'
  end

  test '本へのコメントを削除する' do
    visit book_url(@cherry_book)

    page.accept_confirm do
      click_button '削除', match: :first
    end

    assert_text 'コメントが削除されました。'
  end

  test '日報へのコメントを新規作成する' do
    visit report_url(@alice_report)

    fill_in 'comment_content', with: 'I am getting even more hungry!'
    click_button 'コメントする'

    assert_text 'コメントが作成されました'
    assert_text 'I am getting even more hungry!'
  end

  test '日報へのコメントを削除する' do
    visit report_url(@carol_report)

    page.accept_confirm do
      click_button '削除', match: :first
    end

    assert_text 'コメントが削除されました。'
  end

  test 'ログイン中アカウントの作成したコメントの削除ボタンがあることを確認する' do
    visit report_url(@alice_report)

    comment_elements = all('.comments-container small').find { |comment_element| comment_element.has_text?('Alice') }
    within comment_elements do
      assert_selector 'button', text: '削除'
    end
  end

  test 'ログイン中アカウント以外で作成されたコメントの削除ボタンがないことを確認する' do
    visit report_url(@alice_report)

    comment_elements = all('.comments-container small').find { |comment_element| comment_element.has_no_text?('Alice') }
    within comment_elements do
      refute_selector 'button', text: '削除'
    end
  end
end
