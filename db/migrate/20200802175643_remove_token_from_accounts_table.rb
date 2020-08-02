class RemoveTokenFromAccountsTable < ActiveRecord::Migration[6.0]
  def change
    remove_column :accounts, :token
  end
end
