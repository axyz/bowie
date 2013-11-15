module Bowie
  module Actions
    # Update the selected package
    def self.update(*songs)
      @songs = SongUtils.get_songs
      @local_songs = SongUtils.get_local_songs

      if songs.length > 0
        songs.each do |song|
          name = SongUtils.parse_song_name song
          version = Semver.new(SongUtils.parse_song_version song)
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
  end
end