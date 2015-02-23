class CreateReceipts < ActiveRecord::Migration
  def change
    create_table :receipts do |t|
      t.references :user, index: true
      t.integer :amount
      t.string :paypal_id
      t.text :full_paypal_hash

      t.timestamps
    end
  end
end
