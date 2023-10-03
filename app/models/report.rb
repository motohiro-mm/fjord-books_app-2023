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
    old_mentioned_reports_ids = mentioning_reports.map(&:id)
    new_mentioned_report_ids = ids_in_content(self).map(&:to_i)

    add_mentioned_report_ids = new_mentioned_report_ids - old_mentioned_reports_ids
    add_mentionings(add_mentioned_report_ids, mentionings)

    delete_mentioned_report_ids = old_mentioned_reports_ids - new_mentioned_report_ids
    delete_mentionings(delete_mentioned_report_ids, mentionings)
  end

  def ids_in_content(report)
    report.content.scan(%r{http://localhost:3000/reports/(\d+)}).flatten.uniq
  end

  def add_mentionings(add_mentioned_report_ids, report_mentionings)
    add_mentioned_report_ids.each { |add_mentioned_report_id| report_mentionings.create(mentioned_report_id: add_mentioned_report_id) }
  end

  def delete_mentionings(delete_mentioned_report_ids, report_mentionings)
    delete_mentioned_report_ids.each do |delete_mentioned_report_id|
      delete_mentioning = report_mentionings.find_by(mentioned_report_id: delete_mentioned_report_id)
      delete_mentioning.destroy
    end
  end
end
