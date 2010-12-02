class AddIndexToCommentCreatedAtAndEntryUpdatedAt < ActiveRecord::Migration
  def self.up
    add_index :comments,  :created_at
    add_index :entries,   :updated_at
  end

  def self.down
    remove_index :comments, :column => :created_at
    remove_index :entries,  :column => :updated_at
  end
end
