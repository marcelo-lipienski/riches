class AddLimitToAccountsTable < ActiveRecord::Migration[6.0]
  def change
    add_column :accounts, :limit, :decimal, precision: 8, scale: 2, default: 0
  end
end
