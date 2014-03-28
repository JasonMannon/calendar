class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.column :note, :string
    end
  end
end
