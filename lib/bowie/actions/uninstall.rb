module Bowie
  module Actions
    # Remove the selected package
    def self.uninstall(*songs)
      @songs = SongUtils.get_songs
      @local_songs = SongUtils.get_local_songs

      songs.each do |song|
        name = SongUtils.parse_song_name song
        begin
          version = Semver.new(SongUtils.parse_song_version song)
        rescue 
          version = false
        end
        path = "#{SongUtils.get_bowie_dir}/#{name}"

        FileUtils.rm_rf(path) # use remove_entry_secure for security reasons?

        if version
          @local_songs.delete "#{name}##{version}"
        else
          @local_songs.delete_if {|el| not (el =~ /^#{name}#/).nil?}
        end
        File.open("songs.yml", "w"){|f| YAML.dump(@local_songs, f)}
      end
    end
  end
end