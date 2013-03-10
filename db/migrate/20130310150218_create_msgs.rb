class CreateMsgs < ActiveRecord::Migration
  def change
    create_table :msgs do |t|
      t.string :room
      t.string :sender
      t.text :body

      t.timestamps
    end
  end
end
