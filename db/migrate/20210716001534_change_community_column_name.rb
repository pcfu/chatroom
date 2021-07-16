class ChangeCommunityColumnName < ActiveRecord::Migration[6.0]
  def change
    rename_column :communities, :type, :access
  end
end
