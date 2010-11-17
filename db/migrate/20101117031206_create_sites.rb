class CreateSites < ActiveRecord::Migration
  def self.up
    create_table :sites do |t|
      t.string :url
      t.string :style_sheet_url

      t.timestamps
    end
    
    add_index :sites, :url
  end

  def self.down
    drop_table :sites
  end
end
