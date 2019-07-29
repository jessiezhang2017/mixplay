# This program is to create a Song class
class Song
  def initialize(id, artist, title)
      @id = id
      @artist = artist
      @title = title
  end

  attr_reader :id, :artist, :title
end
