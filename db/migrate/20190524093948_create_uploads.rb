class CreateUploads < ActiveRecord::Migration[5.1]
  def change
    create_table :uploads do |t|
      t.string :dir
      t.string :pfad
      t.text :inhalt

      t.timestamps
    end
  end
end
