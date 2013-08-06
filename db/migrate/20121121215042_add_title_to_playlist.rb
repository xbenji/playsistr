class AddTitleToPlaylist < ActiveRecord::Migration
  def change
    add_column :playlists, :title, :string
  end
end