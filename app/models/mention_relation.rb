class MentionRelation < ApplicationRecord
  belongs_to :mentioning_report, class_name: "Report", optional: true
  belongs_to :mentioned_report, class_name: "Report"
end
