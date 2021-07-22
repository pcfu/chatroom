class CreateMemberships < ActiveRecord::Migration[6.0]
  def up
    create_enum :membership_level, %w(owner moderator regular banned)

    create_table :memberships do |t|
      t.belongs_to  :user
      t.belongs_to  :community
      t.enum        :level, enum_name: :membership_level, null: :false, index: true

      t.timestamps
    end
  end

  def down
    drop_table :memberships

    drop_enum :membership_level
  end
end
