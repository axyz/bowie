module Bowie
  module Actions
    # Return a printable list of available packages matching the [query]
    def self.search(query)
      @songs = SongUtils.get_songs
      @songs.select { |el| /.*#{query}.*/ =~ el }
    end
  end
end