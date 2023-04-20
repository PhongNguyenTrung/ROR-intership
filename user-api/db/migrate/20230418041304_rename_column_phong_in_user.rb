class RenameColumnPhongInUser < ActiveRecord::Migration[7.0]
  def change
    rename_column :users, :phong, :phone
  end
end
