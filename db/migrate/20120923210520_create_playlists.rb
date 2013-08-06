class CreatePlaylists < ActiveRecord::Migration
  def change
    create_table :playlists do |t|
      t.string :uri
      t.string :tid

      t.timestamps
    end
  end
end
