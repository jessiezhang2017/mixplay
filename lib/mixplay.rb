require_relative 'song'
require_relative 'playlist'
require_relative 'user'
require 'json'

class MixplayManager

  attr_reader :users, :songs, :playlists

  def initialize(input_file, changes_file, output_file)
    @users = Hash.new()
    @songs = Hash.new()
    @playlists = Hash.new()
    load_data(input_file)
    process_changes(changes_file)
    print_output(output_file)
  end

  private
  def load_data(input_file)
    json_obj = JSON.parse(File.read("./file/#{input_file}"))

    # load users
    json_obj["users"].each do |user|
      id = user["id"]
      name = user["name"]
      @users[id] = User.new(user["id"], user["name"])
    end

    # load playlist
    json_obj["playlists"].each do |playlist|
      id = playlist["id"]
      user_id = playlist["user_id"]
      song_ids = playlist["song_ids"]

      @playlists[id] = Playlist.new(id, user_id, song_ids[0])
      size = song_ids.length

      if size > 1
        i = 1
        while i < size do
          @playlists[id].songs.push(song_ids[i])
          i += 1
        end
      end

    end
    puts(@playlists)

    # load songs
    json_obj["songs"].each do |song|
      id = song["id"]
      artist = song["artist"]
      title = song["title"]
      @songs[id] = Song.new(id, artist, title)
    end
    puts(@songs)
  end

  def process_changes(change_file)
    # convert Changes_file to a hash
    json_obj = JSON.parse(File.read("./file/#{change_file}"))

    # Process add_song changes
      # Check if add_song exists in hash
      # If so, process add song for each song
    if json_obj["add_song"]
       song_addition = json_obj["add_song"]
      if song_addition.length > 0
        song_addition.each do |item|
          add_song_id(item["playlist_id"], item["song_id"])
        end
      end
    end

    # Process add_playlist changes
    if json_obj["add_playlist"]
      playlist_addition = json_obj["add_playlist"]
      # get all the keys from hash @palylists into an array nanmed arr, and sort
      arr = @playlists.keys.sort
      # get the maximum key number and assign to variable called max_id
      max_id = arr[-1].to_i

      if playlist_addition.length > 0
        playlist_addition.each do |item|
          uid = item["user_id"]
          songs = item["song_ids"]
          max_id += 1
          add_playlist(max_id.to_s, uid, songs)
        end
      end
    end

    # Process delete_playlist changes
    if json_obj["delete_playlist"]
      selected_list = json_obj["delete_playlist"]
      if selected_list.length > 0
        selected_list.each do |item|
           delete_playlist(item["id"])
        end
      end
    end
  end

  def print_output(output_file)

    userlists = Array.new()
    playlists = Array.new()
    songlists = Array.new()

    @users.keys.each do |item|
      userlists << {"id"=>item, "name"=>@users[item].name}
    end

    @playlists.keys.each do |item|
      playlists << {"id"=>item, "user_id"=>@playlists[item].user_id, "songs"=>@playlists[item].songs }
    end

    @songs.keys.each do |item|
      songlists << {"id"=>item, "artist"=>@songs[item].artist, "title"=>@songs[item].title }
    end

    tempHash = {"users"=>userlists, "playlists"=>playlists, "songs"=>songlists }

    output_file = File.open("./file/#{output_file}","w") do |f|
      f.write(JSON.pretty_generate(tempHash))
    end
  end

  # define a method to add a new song to playlist
  def add_song_id(playlist_id, song_id)
    # make sure song_id & playlist_id exists in original input file
    if @songs[song_id] && @playlists[playlist_id]
      # get song fron the songs hash
      song_select = @songs[song_id]
      # get playlist from the playlists hash
      playlist_select = @playlists[playlist_id]

      # Add it to the playlist
      if playlist_select.songs.include? song_id
        puts("song id #{song_select} already added to playlist #{playlist_select}")
      else
        playlist_select.add_song(song_id)
      end
    elsif !@songs[song_id]
      puts("song_id #{song_id} does not exist")
    elsif !@playlists[playlist_id]
      puts("playlist_id #{playlist_id} does not exist")
    end
  end

  def add_playlist(id, user_id, song_ids)
    #check if user_id exist
    if !@users[user_id]
      puts("user id #{user_id} does not exist")

    #check to see if the user_id already has a playlist, one user can only has one playlist
    elsif @playlists[user_id]
      puts("playlist already exists for user #{user_id}, adjust the change to under add_song")

    else
      #check if song_ids is an array
      if song_ids.is_a?(Array)
        if song_ids.length > 0
          song_ids_valid = true

          # check all song_id are valid
          song_ids.each do |song_id|
            if !@songs[song_id]
              puts("changes file > add_playlist > song_ids > song_id #{song_id} does not exist")
              song_ids_valid = false
            end
          end

          if song_ids_valid
            new_playlist = Playlist.new(id, user_id, song_ids[0])
            i = 1
            while(i < song_ids.length) do
              new_playlist.add_song(song_ids[i])
              i += 1
            end
            @playlists[id] = new_playlist
          end
        end
      else
        puts("Changes file > add_playlist > song_ids must be an array")
      end
    end
  end

  def delete_playlist(id)
    # find playlist_id in @playlists
    # remove the selected playlist
    if @playlists[id]
      @playlists.delete(id)
    else
      puts("playlist id #{id} does not exist")
    end
  end
end
