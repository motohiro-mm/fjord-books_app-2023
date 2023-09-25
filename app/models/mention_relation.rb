class MentionRelation < ApplicationRecord
  belongs_to :mentioning_report, class_name: "Report", optional: true
  belongs_to :mentioned_report, class_name: "Report"

  validates :mentioning_report, presence: true
  validates :mentioned_report, presence: true
end
