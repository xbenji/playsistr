namespace :admin do

  desc "Clear all tweets"
  task :clear do
    Playlist.destroy_all
  end

  desc "Update tweets"
  task :update => [:environment] do
    fetcher = TweetFetcher::Fetcher.new
    current_month = Time.now.localtime.strftime("%B")
    puts " * Current month is " + current_month
    puts " * Feching tweets.."

    r = fetcher.fetch(current_month)
    puts " * Saving tweets.."
    #Playlist.destroy_all
    r.each do |tweet|
      unless Playlist.exists? :uri => tweet[:uri]
        p = Playlist.new
        p.tid = tweet[:tid]
        p.uri = tweet[:uri]
        p.tweet_date = tweet[:date]
        p.save
      end
    end
    fetcher.save
  end

  desc "fetch playlists titles and owner"
  task :get_titles => [:environment] do
    require 'scorer.rb'
    " * connect to spotify"
    ph = SpotifyHelper.new

    playlists = Playlist.find_all_by_title(nil)
    playlists.each do |pl|
      puts pl.uri
      playlist = ph.get_playlist pl.uri
      pl.title = playlist.name
      pl.user = playlist.owner.display_name
      puts pl.title
      pl.save
    end
  end

  desc "artists statistics"
  task :artists => [:environment] do
    require 'scorer.rb'
    puts " * connect to spotify"
    ph = SpotifyHelper.new
    artists = {}
    Playlist.where(:tweet_date => 4.week.ago..Time.now).each do |pl|
      puts " *- processing #{pl.title}"
      res = ph.get_playlist_artists pl.uri
      res.keys.each do |a|
        artists[a] ||= 0
        artists[a] += 1
      end
    end
    artists = artists.sort_by {|k,v| v}.reverse
    puts artists[0..20]
    puts " == end"
  end

  desc "artists tags"
  task :tags => [:environment] do

    require 'scorer.rb'

    puts " * connect to spotify"
    ph = SpotifyHelper.new
    lfmh = LastFMHelper.new API_KEY, "xbenji"

    result = {}

    # Playlist.where(:tweet_date => 7.day.ago..Time.now).each do |pl|
    pl_list = Playlist.all.map {|p| p if p.tags.empty? }
    pl_list.each do |pl|

      next unless pl

      puts " * - processing #{pl.title}"
      artists = ph.get_playlist_artists pl.uri

      result = {}

      artists.keys.each do |a|
        puts a
        tags = lfmh.get_artist_tags a
        next if tags.nil? || !tags.kind_of?(Array)
        tags.select { |t| t['count'].to_i > 0}.each do |t|
            result[t['name']] ||= 0
            result[t['name']] += t['count'].to_i
        end
      end

      # sort by count
      result_a = result.sort_by {|k,v| v}.reverse
      # normalize and format as array of objects

      next if result_a.empty?

      max = result_a.first[1]
      result_a = result_a.map { |t| {:name => t[0], :count => 100*t[1]/max}}
      # filter out
      maxcount = 12
      result_a = result_a.select { |t| t[:count] > 10 }[0..maxcount]
      tags = result_a.map { |t| t[:name] }
      puts tags
      pl.tag_list = tags
      pl.save

    end
    ph.close
  end

end