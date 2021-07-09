class CreateCommunities < ActiveRecord::Migration[6.0]
  def up
    create_enum :community_type, %w(public private)

    create_table :communities do |t|
      t.string  :name,                              null: false, index: { unique: true }
      t.string  :description,                       null: false
      t.enum    :type, enum_name: :community_type,  null: false, index: true

      t.timestamps
    end
  end

  def down
    drop_table :communities

    drop_enum :community_type
  end
end
