class AddUserToPlaylist < ActiveRecord::Migration
  def change
    add_column :playlists, :user, :string
  end
end
