module Bowie
  module SongUtils
    # Retrive the online registry of available songs
    def self.get_songs
      begin
        YAML.parse(open("https://raw.github.com/axyz/bowie-songs/master/songs.yml")).to_ruby
      rescue
        puts "ERROR: Cannot connect to github.com"
      end
    end

    # Retrive the local registry of installed songs
    def self.get_local_songs
      begin
        YAML.load_file('songs.yml')? YAML.load_file('songs.yml') : Array.new
      rescue
        begin
          FileUtils.mkdir 'bowie_songs'
        rescue 
        end
        FileUtils.touch 'songs.yml'
        return Array.new
      end
    end

    # Retrive the local lyrics file
    def self.get_local_lyrics
      begin
        YAML.load_file('bowie_songs/lyrics.yml')? YAML.load_file('songs.yml') : Hash.new
      rescue
        begin
          FileUtils.mkdir 'bowie_songs'
        rescue
        end
        FileUtils.touch 'bowie_songs/lyrics.yml'
        return Hash.new
      end
    end

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
  end
end