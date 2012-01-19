class CreateDrops < ActiveRecord::Migration
  def change
    create_table :drops do |t|
      t.string :name
      t.text :content
      t.string :type
      t.string :title
      t.string :layout, :default => 'application.html.erb'
      t.boolean :admin_only, :default => false, :null => false
      t.boolean :user_only, :default => false, :null => false
      t.boolean :show_title, :default => false, :null => false
      
      t.timestamps
    end
  end
end
