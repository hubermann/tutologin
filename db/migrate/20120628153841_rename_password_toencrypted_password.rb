class RenamePasswordToencryptedPassword < ActiveRecord::Migration
  def up
  	rename_column :users, :password, :encrypted_password
  end

  def down
  end
end
