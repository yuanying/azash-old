class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.string :name
      t.string :email
      t.string :url
      t.text :content
      t.string :ip_address
      t.string :user_agent
      t.string :referrer
      
      t.references :entry

      t.timestamps
    end
    add_index :comments, [:entry_id, :created_at]
    add_index :comments, :entry_id
  end

  def self.down
    drop_table :comments
  end
end
