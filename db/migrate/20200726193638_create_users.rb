class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :fullname
      t.string :document
      t.date :birthdate
      t.integer :gender
      t.string :password

      t.timestamps
    end
  end
end
