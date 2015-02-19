class CreateMailingAddresses < ActiveRecord::Migration
  def change
    create_table :mailing_addresses do |t|
      t.references :user, index: true
      t.string :line_1
      t.string :line_2
      t.string :city
      t.string :state
      t.string :zip

      t.integer :users_primary, default: 0

      t.timestamps
    end
  end
end
