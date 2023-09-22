# frozen_string_literal: true

class Report < ApplicationRecord
  after_create :mention_create
  after_update :mention_update

  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy

  has_many :mentioning_relations, foreign_key: "mentioning_report_id", class_name: "MentionRelation", dependent: :destroy
  has_many :mentioning_reports, through: :mentioning_relations, source: :mentioned_report
  has_many :mentioned_relations, foreign_key: "mentioned_report_id", class_name: "MentionRelation", dependent: :destroy
  has_many :mentioned_reports, through: :mentioned_relations, source: :mentioning_report

  validates :title, presence: true
  validates :content, presence: true

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end

  def mention_create
    mentioned_report_ids = self.content.scan(%r!http://localhost:3000/reports/(\d+)!).flatten.uniq
    mentioning_relations = 
    mentioned_report_ids.map do |m_r_id|
      self.mentioning_relations.build(mentioned_report_id: m_r_id)
    end
    mentioning_relations.each(&:save)
  end

  def mention_update
    report_mentioning_relations = self.mentioning_relations
    old_mentioned_reports_ids = self.mentioning_reports.map {|m_r| m_r.id }
    new_mentioned_report_ids = self.content.scan(%r!http://localhost:3000/reports/(\d+)!).flatten.uniq.map(&:to_i)
    add_mentioned_report_ids = new_mentioned_report_ids - old_mentioned_reports_ids
    add_mentioned_report_ids.each do |add_mentioned_report_id|
      report_mentioning_relations.create(mentioned_report_id: add_mentioned_report_id)
    end
    delete_mentioned_report_ids = old_mentioned_reports_ids - new_mentioned_report_ids
    delete_mentioned_report_ids.each do |delete_mentioned_report_id|
      delete_relation = report_mentioning_relations.find_by(mentioned_report_id: delete_mentioned_report_id)
      delete_relation.destroy
    end
  end
end
