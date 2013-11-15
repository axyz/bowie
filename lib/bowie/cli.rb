require 'thor'

module Bowie
  class CLI < Thor

    SongUtils.get_songs
    SongUtils.get_local_songs
    SongUtils.get_local_lyrics
    
    desc "install [song]", "install the selected package"
    def install(*songs)
      Actions.install(*songs)
    end

    desc "update [song]", "update the selected package"
    def update(*songs)
      Actions.update(*songs)
    end

    desc "uninstall [song]", "remove the selected package"
    def uninstall(*songs)
      Actions.uninstall(*songs)
    end

    desc "search [song]", "list all availables packages matching [song]"
    def search(song)
      results = Bowi::Actions.search(song)
      results.each { |key, values| puts "#{values['name']}:\n  #{values['description']}" }
    end

    desc "prune", "remove all the packages not included in songs.yml"
    def prune
      Actions.prune
    end

    desc "list", "list all the installed packages"
    def list
      results = Actions.list
      results.each { |key, values| puts "#{values['name']}:\n  #{values['description']}" }
    end
  end
end