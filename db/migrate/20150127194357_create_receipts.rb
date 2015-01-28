class CreateReceipts < ActiveRecord::Migration
  def change
    create_table :receipts do |t|
      t.references :user, index: true
      t.integer :amount

      t.timestamps
    end
  end
end
