# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  test 'mentions' do
    alice_report = reports(:alice_report)
    carol_report = reports(:carol_report)

    assert_not_includes(carol_report.mentioning_reports, alice_report)

    carol_report.update!(content: "http://localhost:3000/reports/#{alice_report.id} Are you still hungry? You eat too much!")

    assert_includes(carol_report.mentioning_reports, alice_report)
  end
end
