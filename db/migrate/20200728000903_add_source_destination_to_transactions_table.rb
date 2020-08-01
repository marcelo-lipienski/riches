class AddSourceDestinationToTransactionsTable < ActiveRecord::Migration[6.0]
  def change
    add_column :transactions, :source_account_id, :integer
    add_column :transactions, :destination_account_id, :integer
  end
end
