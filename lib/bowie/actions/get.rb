module Bowie
  module Actions
    # List all the installed packages
    def self.get(song, key)
      unless SongUtils.installed_song? song
        raise "song not installed"
      end
      begin
        @lyrics = YAML.load_file("#{SongUtils.get_bowie_dir}/#{song}/bowie.yml")
      rescue
        raise "bowie.yml not found"
      end

      return @lyrics[key]
    end
  end
end