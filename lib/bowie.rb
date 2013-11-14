require "bowie/version"
require "yaml"
require "open-uri"
require "fileutils"
require "git"
require "logger"
require "bowie/utils"
require "bowie/semver"

module Bowie

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

  # Return a printable list of available packages matching the [query]
  def self.search(query)
    @songs = self.get_songs
    @songs.select { |el| /.*#{query}.*/ =~ el }
  end

  # Install the selected [song] in the bowie_songs directory
  def self.install(*songs)
    @songs = self.get_songs
    @local_songs = self.get_local_songs

    if songs.length > 0
      songs.each do |song|
        name = Utils.parse_song_name song
        version = Semver.new(Utils.parse_song_version song)
        url = @songs[name]['url']
        path = "bowie_songs/#{name}"

        if File.directory? path
          self.update(name)
        else
          FileUtils.mkdir_p(path)
          Git.clone(url, path)
          if version.major != nil
            g = Git.open(path)
            begin
              g.checkout(version.to_s)
            rescue
              begin
                g.checkout(version.to_s :v => true)
              rescue
              end
            end
          end
        end

        unless @local_songs.include? name or @local_songs.include? name+'#'+version.to_s
          version.major ? @local_songs.push(name+'#'+version.to_s) : @local_songs.push(name)
        end
        File.open("songs.yml", "w"){|f| YAML.dump(@local_songs, f)}
      end
    else
      @local_songs.each {|song| self.install(song)}
    end
  end

  # Remove the selected package
  def self.uninstall(*songs)
    @songs = self.get_songs
    @local_songs = self.get_local_songs

    songs.each do |song|
      name = Utils.parse_song_name song
      version = Semver.new(Utils.parse_song_version song)
      path = "bowie_songs/#{name}"

      FileUtils.rm_rf(path) # use remove_entry_secure for security reasons?

      if version.major != nil
        @local_songs.delete "#{name}##{version}"
      else
        @local_songs.delete_if {|el| not (el =~ /^#{name}#/).nil?}
      end
      File.open("songs.yml", "w"){|f| YAML.dump(@local_songs, f)}
    end
  end

  # Update the selected package
  def self.update(*songs)
    @songs = self.get_songs
    @local_songs = self.get_local_songs

    if songs.length > 0
      songs.each do |song|
        name = Utils.parse_song_name song
        version = Semver.new(Utils.parse_song_version song)
        path = "bowie_songs/#{name}"

        g = Git.open(path, :log => Logger.new(STDOUT))
        g.reset_hard('HEAD')
        g.pull
        unless version.major.nil?
          begin
            g.checkout(version.to_s)
          rescue
            begin
              g.checkout(version.to_s :v => true)
            rescue
            end
          end
        end
        @local_songs.delete name
        @local_songs.delete_if {|el| not (el =~ /^#{name}#/).nil?}
        version.major ? @local_songs.push(name+'#'+version.to_s) : @local_songs.push(name)
        File.open("songs.yml", "w"){|f| YAML.dump(@local_songs, f)}
      end
    else
      @local_songs.each {|song| self.update(song)}
    end
  end

  # Remove all the packages not included in songs.yml
  def self.prune
    @local_songs = self.get_local_songs
    
    Utils.get_songs_dirs.each do |dir|
      unless @local_songs.include? dir
        FileUtils.rm_rf("bowie_songs/#{dir}")
      end
    end
  end

  # List all the installed packages
  def self.list
    @local_songs = self.get_local_songs
    @songs = self.get_songs

    @songs.select {|el| @local_songs.include? el}
  end

end
