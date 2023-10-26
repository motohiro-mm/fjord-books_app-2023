# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test '#name_or_email' do
    dave = users(:dave)

    assert_equal 'dave@example.com', dave.name_or_email

    dave.name = 'Dave'
    assert_equal 'Dave', dave.name_or_email
  end
end
