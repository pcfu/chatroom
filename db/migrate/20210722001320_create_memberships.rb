class CreateMemberships < ActiveRecord::Migration[6.0]
  def up
    create_enum :membership_role, %w(owner moderator regular banned)

    create_table :memberships do |t|
      t.belongs_to  :user
      t.belongs_to  :community
      t.enum        :role, enum_name: :membership_role, null: :false, index: true

      t.timestamps
    end
  end

  def down
    drop_table :memberships

    drop_enum :membership_role
  end
end
