require 'httparty'
require 'json'
require 'hallon'

API_KEY = ""

def loadandwait(obj)
  obj.load(5)
rescue Interrupt
  puts "Interrupted!"
  exit
rescue Exception => e
  puts e.message
  retry
end

class SpotifyHelper

  def initialize
    s_appkey_path = File.expand_path('../spotify_appkey.key', __FILE__)

    if Hallon::Session.instance?
      @session = Hallon::Session.instance
    else
      @session = Hallon::Session.initialize IO.read(s_appkey_path)
    end

    @session.login!('xbenji', 'Jaimelamusique') unless @session.logged_in?
    container = @session.container
    loadandwait(container)
    puts " * connected"

  end

  def get_playlist(p_uri)
    playlist = Hallon::Playlist.new(p_uri).load
    #loadandwait playlist
    playlist.update_subscribers
    playlist.owner.load

    tracks = playlist.tracks.to_a
    tracks.each(&:load)
    playlist

  end

  def get_playlist_artists(p_uri)
    playlist = Hallon::Playlist.new(p_uri).load
    #loadandwait playlist
    playlist.update_subscribers
    playlist.owner.load
    #puts " * loaded #{playlist.name}"

    tracks = playlist.tracks.to_a #.map(&:load)
    tracks.each(&:load)

    a = {}
    tracks.each do |track|
      a[track.artist.name] ||= 0
      a[track.artist.name] += 1
    end

    a

  end

  def close
    @session.logout
  end

end


class LastFMHelper
  include HTTParty
  base_uri 'ws.audioscrobbler.com/2.0'
  format :json
  attr_accessor :api_key

  def initialize(api_key, user)
    @api_key = api_key
    @user = user
    @format = :json
  end

  def get_top_artists
    res = self.class.get('/', { :query => { :method => 'user.gettopartists', \
                                      :user => @user, \
                                      :period => '12month', \
                                      :api_key => @api_key, \
                                      :limit => 250, \
                                      :format => @format }}).parsed_response;
    res['topartists']['artist']
  end

  def get_artist_tags artist
    res = self.class.get('/', { :query => { :method => 'artist.getTopTags', \
                                        :artist => artist, \
                                        :api_key => @api_key, \
                                        :format => @format }}).parsed_response;

    if res['toptags']
      res['toptags']['tag']
    end
  end

end

if __FILE__ == $0

  lfmh = LastFMHelper.new API_KEY, "xbenji"
  artists_fm = lfmh.get_top_artists
  puts " * loaded #{artists_fm.size} artists"

  " * connect to spotify"
  ph = SpotifyHelper.new
  artists = ph.get_playlist_artists 'spotify:user:nickdavis:playlist:40zHmip6SdUzajlI699v8S'
  puts artists

  #puts

end