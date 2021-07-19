class AddTagsToCommunities < ActiveRecord::Migration[6.0]
  def change
    add_column :communities, :tag, :string, null: false, index: { unique: true }
  end
end
