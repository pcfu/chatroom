class AddHandlesToCommunities < ActiveRecord::Migration[6.0]
  def change
    add_column :communities, :handle, :string, null: false, index: { unique: true }
  end
end
