class RenameTypeColumnFromTransactionsTable < ActiveRecord::Migration[6.0]
  def change
    rename_column :transactions, :type, :transaction_type
  end
end
