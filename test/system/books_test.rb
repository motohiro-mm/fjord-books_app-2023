# frozen_string_literal: true

require 'application_system_test_case'

class BooksTest < ApplicationSystemTestCase
  setup do
    @cherry_book = books(:cherry_book)

    visit root_url
    alice_login
  end

  test '本の一覧ページを表示する' do
    visit books_url
    assert_selector 'h1', text: '本の一覧'
  end

  test '本の詳細ページを表示する' do
    visit books_url
    click_on 'この本を表示', match: :first

    assert_selector 'h1', text: '本の詳細'
  end

  test '本を新規作成しその詳細ページを表示する' do
    visit books_url
    click_on '本の新規作成'

    fill_in 'タイトル', with: 'Ruby超入門'
    fill_in 'メモ', with: 'Rubyの文法の基本をやさしくていねいに解説しています。'
    fill_in '著者', with: '五十嵐 邦明'
    click_on '登録する'

    assert_text '本が作成されました。'
    assert_text 'Ruby超入門'
    assert_text 'Rubyの文法の基本をやさしくていねいに解説しています。'
    assert_text '五十嵐 邦明'
  end

  test '本を編集しその詳細ページを表示する' do
    visit book_url(@cherry_book)
    click_on 'この本を編集', match: :first

    fill_in 'タイトル', with: "#{@cherry_book.title} 改訂第二版"
    fill_in 'メモ', with: "#{@cherry_book.memo}とても分かりやすい!!!"
    fill_in '著者', with: "#{@cherry_book.author} さん"
    click_on '更新する'

    assert_text '本が更新されました。'
    assert_text 'プロを目指す人のためのRuby入門 改訂第二版'
    assert_text 'プログラミング経験者のためのRuby入門書です。とても分かりやすい!!!'
    assert_text '伊藤 淳一 さん'
  end

  test '本を削除し一覧ページへ戻る' do
    visit book_url(@cherry_book)
    click_on 'この本を削除', match: :first

    assert_text '本が削除されました。'
    assert_selector 'h1', text: '本の一覧'
    refute_text 'プロを目指す人のためのRuby入門'
    refute_text 'プログラミング経験者のためのRuby入門書です。'
  end
end
