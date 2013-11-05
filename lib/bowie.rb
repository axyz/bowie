require "bowie/version"
require "yaml"
require "open-uri"
require "fileutils"
require "git"

module Bowie
  
  @songs = YAML.parse(open("https://raw.github.com/axyz/bowie-songs/master/songs.yml")).to_ruby

  def self.get_songs
    @songs
  end

  def self.list
    @songs.each_key do |song|
      puts @songs[song]['name'] + ': ' + @songs[song]['description']
    end
  end

  def self.install(song)
    name = @songs[song]['name']
    url = @songs[song]['url']
    path = "bowie_songs/#{name}"

    puts "name: #{name}, url: #{url}" #TO-DELETE

    FileUtils.mkdir_p(path)
    Git.clone(url, path)
  end

end
