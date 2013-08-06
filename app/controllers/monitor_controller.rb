
class MonitorController < ApplicationController

  def index
  end

  def chart
    month = params[:month] || Time.now.month
    year = params[:year] || Time.now.year
    @data = Playlist.tweet_count_per_day year.to_i, month.to_i

    respond_to do |format|
      format.json  { render :json => @data.to_json}
    end

  end
end
