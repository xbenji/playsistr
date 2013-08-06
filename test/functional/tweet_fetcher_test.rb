require "test/unit"

class TweetFetcherTest < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    # Do nothing
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

  def test_fetcher

    tf = TweetFetcher::Fetcher.new

    uri = tf.get_spotify_uri 'http://open.spotify.com/user/crisfont1/playlist/0E52wUeRVizvoe9caF48bg'
    assert_equal "spotify:user:crisfont1:playlist:0E52wUeRVizvoe9caF48bg", uri

    uri = tf.get_spotify_uri 'http://open.spotify.com/user/1238389273/playlist/21AGO4C0XoKIazJkl5Vppr?utm_source=dlvr.it&utm_medium=twitter'
    assert_equal "spotify:user:1238389273:playlist:21AGO4C0XoKIazJkl5Vppr", uri

  end
end