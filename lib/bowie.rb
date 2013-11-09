require "bowie/version"
require "yaml"
require "open-uri"
require "fileutils"
require "git"
require "logger"

module Bowie
  
  @songs
  @local_songs
  @local_lyrics

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
        name = @songs[song]['name']
        url = @songs[song]['url']
        path = "bowie_songs/#{name}"

        FileUtils.mkdir_p(path)
        Git.clone(url, path)

        unless @local_songs.include? song
          @local_songs.push song
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
      name = @songs[song]['name']
      path = "bowie_songs/#{name}"

      FileUtils.rm_rf(path) # use remove_entry_secure for security reasons?

      @local_songs.delete song
      File.open("songs.yml", "w"){|f| YAML.dump(@local_songs, f)}
    end
  end

  # Update the selected package
  def self.update(*songs)
    @songs = self.get_songs
    @local_songs = self.get_local_songs

    if songs.length > 0
      songs.each do |song|
        name = @songs[song]['name']
        path = "bowie_songs/#{name}"

        g = Git.open(path, :log => Logger.new(STDOUT))
        g.reset_hard('HEAD')
        g.pull
      end
    else
      @local_songs.each {|song| self.update(song)}
    end
  end

end
