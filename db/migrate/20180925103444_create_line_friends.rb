class CreateLineFriends < ActiveRecord::Migration[5.2]
  def change
    create_table :line_friends do |t|
      t.string :line_id
      t.string :display_name

      t.timestamps
    end
  end
end
