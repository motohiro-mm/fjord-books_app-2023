# frozen_string_literal: true

class MentionRelation < ApplicationRecord
  belongs_to :mentioning_report, class_name: 'Report'
  belongs_to :mentioned_report, class_name: 'Report'

  validates :mentioning_report, uniqueness: { scope: :mentioned_report }
end
