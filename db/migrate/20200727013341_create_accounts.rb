class CreateAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :accounts do |t|
      t.string :number
      t.string :agency
      t.decimal :balance, precision: 8, scale: 2
      t.string :token
      t.timestamps
    end
  end
end
