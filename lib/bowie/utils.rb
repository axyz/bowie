module Bowie
  module Utils

    # Return an array with all the direcotry inside bowye_songs
    def self.get_songs_dirs
      result = []
      Dir.foreach('bowie_songs') do |el|
        unless (el == "." or el == ".." or el == "lyrics.yml")
          result.push el
        end
      end
      result
    end

  end
end