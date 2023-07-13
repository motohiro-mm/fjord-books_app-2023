class RenameIntroductionToUsers < ActiveRecord::Migration[7.0]
  def change
    rename_column :users, :introduction, :profile
  end
end
