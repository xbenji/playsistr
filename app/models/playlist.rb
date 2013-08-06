class Playlist < ActiveRecord::Base
  validate :get_tweet_details
  attr_accessible :tid, :uri
  default_scope :order => "tweet_date DESC"
  acts_as_ordered_taggable

  def get_tweet_details
    require 'time'

    res = HTTParty::get("https://api.twitter.com/1/statuses/oembed.json?id=#{self.tid}&omit_script=true&maxwidth=420")
    if [403, 404].index res.code
      errors.add("tweets","http error")
      return false
    end

    html_code = res.parsed_response['html']
    if html_code.nil?
      errors.add("tweets","parse error")
      return false
    end

    self.tweet_html = html_code
  end

  def self.tweet_count_per_day year, month
    data = {}
    data['xs'] = []
    data['ys'] = []
    start_date = Date.new(year=year, month=month)
    end_date = start_date + 1.month

    time = start_date
    while time < end_date
      count = self.where(tweet_date: time.beginning_of_day..time.end_of_day).count
      data['xs'] << time.day
      data['ys'] << count
      time += 1.day
    end
    data
  end

end
