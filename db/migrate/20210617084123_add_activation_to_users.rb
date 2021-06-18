class AddActivationToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :active_digest, :string
    add_column :users, :actived, :boolean, default: false
    add_column :users, :activated_at, :datetime
  end
end
