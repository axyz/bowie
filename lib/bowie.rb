require "bowie/version"
require "yaml"
require "open-uri"

module Bowie
  
  @songs = YAML.parse(open("https://raw.github.com/axyz/bowie-songs/master/songs.yml")).to_ruby
  
  def self.test
    puts "ciao"
  end

  def self.list
    @songs
  end

end
