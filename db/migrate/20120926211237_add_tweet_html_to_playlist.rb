class AddTweetHtmlToPlaylist < ActiveRecord::Migration
  def change
    add_column :playlists, :tweet_html, :text
  end
end
