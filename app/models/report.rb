# frozen_string_literal: true

class Report < ApplicationRecord
  after_create :create_mention
  after_update :update_mention

  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy

  has_many :mentionings, foreign_key: 'mentioning_report_id', class_name: 'MentionRelation', inverse_of: :mentioning_report, dependent: :destroy
  has_many :mentioning_reports, through: :mentionings, source: :mentioned_report
  has_many :mentioneds, foreign_key: 'mentioned_report_id', class_name: 'MentionRelation', inverse_of: :mentioned_report, dependent: :destroy
  has_many :mentioned_reports, through: :mentioneds, source: :mentioning_report

  validates :title, presence: true
  validates :content, presence: true

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end

  def create_mention
    report_mentionings =
      ids_in_content(self).map do |id|
        mentionings.build(mentioned_report_id: id)
      end
    report_mentionings.each(&:save)
  end

  def update_mention
    old_mentioned_reports_ids = mentioning_reports.ids
    new_mentioned_report_ids = ids_in_content(self)

    additional_mentioned_report_ids = new_mentioned_report_ids - old_mentioned_reports_ids
    add_mentionings(additional_mentioned_report_ids)

    unnecessary_mentioned_report_ids = old_mentioned_reports_ids - new_mentioned_report_ids
    delete_mentionings(unnecessary_mentioned_report_ids)
  end

  def ids_in_content(report)
    report.content.scan(%r{http://localhost:3000/reports/(\d+)}).flatten.uniq.map(&:to_i)
  end

  def add_mentionings(additional_mentioned_report_ids)
    additional_mentioned_report_ids.each { |additional_mentioned_report_id| mentionings.create(mentioned_report_id: additional_mentioned_report_id) }
  end

  def delete_mentionings(unnecessary_mentioned_report_ids)
    mentionings.where(mentioned_report_id: unnecessary_mentioned_report_ids).destroy_all
  end
end
