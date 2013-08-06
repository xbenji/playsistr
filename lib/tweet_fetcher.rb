require 'twitter'
require 'open-uri'

module TweetFetcher

  class Fetcher

    @@last_rt

    Trans = { 'January' => 'Janvier',
              'February' => 'Fevrier',
              'March' => 'Mars',
              'April' => 'Avril',
              'May' => 'Mai',
              'June' => 'Juin',
              'July' => 'Juillet',
              'August' => 'Aout',
              'September' => 'Septembre',
              'October' => 'Octobre',
              'November' => 'Novembre',
              'December' => 'Decembre'}

    def initialize

      Twitter.configure do |config|
        config.consumer_key = ENV["CONSUMER_KEY"]
        config.consumer_secret = ENV["CONSUMER_SECRET"]
        config.oauth_token = ENV["OAUTH_TOKEN"]
        config.oauth_token_secret = ENV["OAUTH_TOKEN_SECRET"]
      end

      @@last_rt = load_last_rt

    end

    def save
      save_last_rt @@last_rt
    end

    def save_last_rt(last_rt_id)
      begin
        open("lib/assets/last_rt_id.txt", "w") do |f|
          f.puts last_rt_id
        end
        puts "last_tweet: #{last_rt_id}"
      rescue => e
        puts "file save error: " + e.message
      end
    end

    def load_last_rt
      begin
        open("lib/assets/last_rt_id.txt", "r") do |f|
          data = f.readlines
          data[0].to_i
        end
      rescue => e
        puts "file load error: " + e.message
      end
    end

    def get_spotify_uri(url)
      if url =~ /http:\/\/open\.spotify\.com\/user\/.+\/playlist\/.+/
        match =  url.gsub(/\//, ":").scan(/user:\w+:playlist:\w+/)
        unless match.empty?
          return "spotify:" + match[0]
        end
      end
      nil
    end

    def fetch(month)
      results = []

      Twitter.search("spotify playlist #{month} OR #{Trans[month]}", :rpp => 300, :result_type => "recent", :include_entities => true).results.map do |s|
        break if s.id == @@last_rt
        unless s.text =~ /.*RT.*/ or s.urls.empty?
          print "#"
          s.urls.each do |url|
            begin
              open(url.expanded_url) do |final_url|
                s_uri = get_spotify_uri(final_url.base_uri.to_s)
                if s_uri
                  results << {:tid => s.id, :uri => s_uri, :date => s.created_at}
                end
              end
            rescue
              print "x"
            end
          end
        end
      end
      @@last_rt = results.first[:tid]
      results
    end

  end
end