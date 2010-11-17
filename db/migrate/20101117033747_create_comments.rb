class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.string :name
      t.string :email
      t.string :url
      t.text :body_text
      t.references :entry

      t.timestamps
    end
    add_index :comments, [:entry_id, :updated_at]
    add_index :comments, :entry_id
  end

  def self.down
    drop_table :comments
  end
end
