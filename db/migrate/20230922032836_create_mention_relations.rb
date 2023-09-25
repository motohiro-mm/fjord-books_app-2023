class CreateMentionRelations < ActiveRecord::Migration[7.0]
  def change
    create_table :mention_relations do |t|
      t.references :mentioning_report, foreign_key: { to_table: :Reports }, null: false
      t.references :mentioned_report, foreign_key: { to_table: :Reports }, null: false

      t.timestamps
      t.index [:mentioning_report_id, :mentioned_report_id], unique: true, name: "mention_report_id"
    end
  end
end
