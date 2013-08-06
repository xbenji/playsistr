class AddTweetDateToPlaylist < ActiveRecord::Migration
  def change
    add_column :playlists, :tweet_date, :datetime
  end
end
