class CreateAddresses < ActiveRecord::Migration[6.0]
  def change
    create_table :addresses do |t|
      t.string :country
      t.string :state
      t.string :city
      t.string :district
      t.string :street
      t.string :number
      t.string :complement
      t.string :zip_code

      t.timestamps
    end
  end
end
