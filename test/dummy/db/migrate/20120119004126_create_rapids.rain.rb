# This migration comes from rain (originally 20091030141230)
class CreateRapids < ActiveRecord::Migration
  def change
    create_table :rapids do |t|
      t.integer :parent_id
      t.string :name
      t.string :link
      t.string :classes
      t.boolean :admin_only, :default => false, :null => false
      t.boolean :user_only, :default => false, :null => false
      t.string :title
      t.integer :position
      
      t.timestamps
    end
  end
end
