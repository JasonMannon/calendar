class AddNoteIdToEvents < ActiveRecord::Migration
  def change
    add_column :events, :note_id, :integer
    add_column :todos, :note_id, :integer
  end
end
