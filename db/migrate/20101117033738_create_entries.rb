class CreateEntries < ActiveRecord::Migration
  def self.up
    create_table :entries do |t|
      t.string :path
      t.references :site

      t.timestamps
    end
    add_index :entries, :path
    add_index :entries, :site_id
  end

  def self.down
    drop_table :entries
  end
end
