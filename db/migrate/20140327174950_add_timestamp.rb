class AddTimestamp < ActiveRecord::Migration
  def change
    remove_column :events, :time
    add_column :events, :created_at, :timestamp
    add_column :events, :updated_at, :timestamp
  end
end
