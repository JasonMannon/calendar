class CreateTodo < ActiveRecord::Migration
  def change
    create_table :todos do |t|
      t.column :task, :string
      t.column :description, :string

      t.timestamps
    end
  end
end
