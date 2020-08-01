class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.integer :type
      t.decimal :amount, precision: 8, scale: 2

      t.timestamps
    end
  end
end
