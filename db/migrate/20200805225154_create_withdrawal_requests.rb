class CreateWithdrawalRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :withdrawal_requests, id: :uuid do |t|
      t.references :account, null: false, foreign_key: true
      t.decimal :amount, precision: 8, scale: 2

      t.timestamps
    end
  end
end
