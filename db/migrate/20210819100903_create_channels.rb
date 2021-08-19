class CreateChannels < ActiveRecord::Migration[6.0]
  def up
    create_table :channels do |t|
      t.references  :community,   null: false, foreign_key: true
      t.string      :name,        null: false
      t.text        :description

      t.timestamps
    end

    add_index :channels, [:community_id, :name], unique: true
  end

  def down
    remove_index :channels, [:community_id, :name]

    drop_table :channels
  end
end
