require "git"

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

    # Parse the name of a package in the form name#version
    def self.parse_song_name(s)
      s.split("#")[0]
    end

    # Parse the version of a package in the form name#version
    def self.parse_song_version(s)
      s.split("#")[1]
    end

    def self.get_git_tags(path)
      result = Array.new
      g = Git.open(path)
      g.tags.each do |tag|
        result.push tag.name
      end
      return result
    end

  end
end