module Bowie
  module Actions
    # Remove all the packages not included in songs.yml
    def self.prune
      @local_songs = SongUtils.get_local_songs
      
      SongUtils.get_songs_dirs.each do |dir|
        unless @local_songs.include? dir
          FileUtils.rm_rf("#{SongUtils.get_bowie_dir}/#{dir}")
        end
      end
    end
  end
end