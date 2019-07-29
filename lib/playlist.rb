
class Playlist
  attr_reader :user_id, :songs, :id

  # need to provide a user id and a song_id to create a new playlist
  def initialize(id, user_id, song_id)
    @id = id
    @user_id = user_id
    @songs = [song_id]

  end

  # add an additional song to playlist
  def add_song(song_id)
    @songs.push(song_id)
  end

end
