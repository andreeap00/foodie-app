class CreateArchivedOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :archived_orders do |t|
      t.integer :status

      t.timestamps
    end
  end
end
