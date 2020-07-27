class AddUserToAddressesTable < ActiveRecord::Migration[6.0]
  def change
    add_reference :addresses, :user, foreign_key: true
  end
end
