class AddPasswordDigestToUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :password, :text
    add_column :users, :password_digest, :text
  end
end
