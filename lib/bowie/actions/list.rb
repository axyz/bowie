module Bowie
  module Actions
    # List all the installed packages
    def self.list
      @local_songs = SongUtils.get_local_songs
      @songs = SongUtils.get_songs

      @songs.select {|el| @local_songs.include? el}
    end
  end
end