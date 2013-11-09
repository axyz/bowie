require "bowie/version"
require "yaml"
require "open-uri"
require "fileutils"
require "git"
require "logger"

module Bowie
  
  # Parse the remote list of packages
  @songs = YAML.parse(open("https://raw.github.com/axyz/bowie-songs/master/songs.yml")).to_ruby

  # Returns the list of packages
  def self.get_songs
    @songs
  end

  # Return a printable list of available packages matching the [query]
  def self.search(query)
    @songs.select { |el| /.*#{query}.*/ =~ el }
  end

  # Install the selected [song] in the bowie_songs directory
  def self.install(song)
    name = @songs[song]['name']
    url = @songs[song]['url']
    path = "bowie_songs/#{name}"

    FileUtils.mkdir_p(path)
    Git.clone(url, path)
  end

  # Remove the selected package
  def self.uninstall(song)
    name = @songs[song]['name']
    path = "bowie_songs/#{name}"

    FileUtils.rm_rf(path) # use remove_entry_secure for security reasons?
  end

  # Update the selected package
  def self.update(song)
    name = @songs[song]['name']
    path = "bowie_songs/#{name}"

    g = Git.open(path, :log => Logger.new(STDOUT))
    g.reset_hard('HEAD')
    g.pull
  end

end
