# frozen_string_literal: true

class Report < ApplicationRecord
  after_save :save_mentions

  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy

  has_many :sent_mentions, foreign_key: 'mentioning_report_id', class_name: 'Mention', inverse_of: :mentioning_report, dependent: :destroy
  has_many :mentioning_reports, through: :sent_mentions, source: :mentioned_report
  has_many :received_mentions, foreign_key: 'mentioned_report_id', class_name: 'Mention', inverse_of: :mentioned_report, dependent: :destroy
  has_many :mentioned_reports, through: :received_mentions, source: :mentioning_report

  validates :title, presence: true
  validates :content, presence: true

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end

  private

  def save_mentions
    if sent_mentions.exists?
      old_mentioned_reports_ids = mentioning_reports.ids
      new_mentioned_report_ids = ids_in_content(self)
      send_mentions(new_mentioned_report_ids - old_mentioned_reports_ids)
      delete_mentions(old_mentioned_reports_ids - new_mentioned_report_ids)
    else
      send_mentions(ids_in_content(self))
    end
  end

  def ids_in_content(report)
    report.content.scan(%r{http://localhost:3000/reports/(\d+)}).flatten.uniq.map(&:to_i)
  end

  def send_mentions(report_ids)
    report_ids.each do |report_id|
      additional_mentions = sent_mentions.build(mentioned_report_id: report_id)
      additional_mentions.save! if additional_mentions.valid?
    end
  end

  def delete_mentions(report_ids)
    sent_mentions.where(mentioned_report_id: report_ids).destroy_all
  end
end
