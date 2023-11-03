# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  test '#editable?' do
    alice = users(:alice)
    alice_report = reports(:alice_report)
    carol_report = reports(:carol_report)

    assert alice_report.editable?(alice)
    refute carol_report.editable?(alice)
  end

  test '#created_on' do
    alice_report = reports(:alice_report)

    assert_equal(alice_report.created_at.to_date, alice_report.created_on)
  end

  test 'mentions' do
    alice_report = reports(:alice_report)
    carol_report = reports(:carol_report)

    assert_not_includes(carol_report.mentioning_reports, alice_report)

    carol_report.update!(content: "http://localhost:3000/reports/#{alice_report.id} Are you still hungry? You eat too much!")

    assert_includes(carol_report.mentioning_reports, alice_report)
  end
end
