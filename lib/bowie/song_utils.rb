module Bowie
  module SongUtils

    def self.get_bowie_dir
      if File.exist? '.bowierc'
        f = YAML.load_file '.bowierc'
        (f['bowie-dir'] == nil) ? (return 'bowie_songs') : (return f['bowie-dir'])
      else 
        return 'bowie_songs'
      end
    end

    # Retrive the online registry of available songs
    def self.get_songs
      begin
        YAML.parse(open("https://raw.github.com/axyz/bowie-songs/master/songs.yml")).to_ruby
      rescue
        raise "cannot connect to github.com"
      end
    end

    # Retrive the local registry of installed songs
    def self.get_local_songs
      if File.exist? 'songs.yml'
        if self.valid_songs_file? 'songs.yml'
          self.check_songs_dir
          return YAML.load_file('songs.yml')
        else
          raise "songs.yml is not valid"
        end
      else
        self.create_empty_songs_file
        self.check_songs_dir
        return Array.new
      end
    end

    # Retrive the local lyrics file
    def self.get_local_lyrics
      if File.exist? "#{self.get_bowie_dir}/lyrics.yml"
        if self.valid_lyrics_file? "#{self.get_bowie_dir}/lyrics.yml"
          return YAML.load_file("#{self.get_bowie_dir}/lyrics.yml")
        else
          raise "#{self.get_bowie_dir}/lyrics.yml is not valid"
        end
      else
        self.check_songs_dir
        self.create_empty_lyrics_file
        return Hash.new
      end
    end

    # Return an array with all the direcotry inside bowye_songs
    def self.get_songs_dirs
      result = []
      Dir.foreach(self.get_bowie_dir) do |el|
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

    def self.valid_songs_file?(file)
      begin
        f = YAML.load_file file
        f.each do |s|
          unless valid_song? s
            return false
          end
        end
        return true
      rescue
        return false
      end
    end

    def self.valid_song?(string)
      (string =~ /\A[a-z0-9]+(-?[a-z0-9])*(#\d+.\d+.\d+)?\z/) == nil ? false : true
    end

    def self.installed_song? (song)
      @songs = self.get_local_songs
      @dirs = self.get_songs_dirs

      unless (@songs.grep /#{song}/).empty?
        if (@dirs.grep /#{song}/).empty?
          return false
        else 
          return true
        end
      end
      return false
    end

    def self.valid_lyrics_file?(file)
      begin
        f = YAML.load_file file
        (f.is_a? Hash)? true : false
      rescue
        false
      end
    end

    def self.create_empty_songs_file
      File.open("./songs.yml", "w"){|f| YAML.dump(Array.new, f)}
    end

    def self.check_songs_dir
      unless File.directory? self.get_bowie_dir
        FileUtils.mkdir self.get_bowie_dir
      end
    end

    def self.create_empty_lyrics_file
      File.open("./#{self.get_bowie_dir}/lyrics.yml", "w"){|f| YAML.dump(Hash.new, f)}
    end

  end
end