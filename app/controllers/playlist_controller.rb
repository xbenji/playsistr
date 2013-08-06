
class PlaylistController < ApplicationController

  def index

    @playlists = Playlist.limit(6)

    respond_to do |format|
      format.html # index.html.erb
      format.json  { render :json => @jobs }
    end

  end

  def home

    step = 9

    limit = params[:limit] || step
    offset = params[:page].to_i || 0
    offset *= step

    if params[:tags]
      @playlists = Playlist.tagged_with(params[:tags].split).limit(limit).offset(offset)
    else
      @playlists = Playlist.all :limit =>  limit, :offset => offset
    end

    @tags = tag_list 42

    render :home

  end

  def api_get_feed

    params[:limit] ||= 25
    params[:page] ||= 0

    @playlists = Playlist.all :limit =>  params[:limit], :offset => params[:page]

    respond_to do |format|
      format.json  { render :json => @playlists }
    end
  end

  def tag_list limit
    Playlist.tag_counts.sort_by { |p| p.count }.reverse[0..limit]
  end

end
