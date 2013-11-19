module Bowie
  module Actions
    def self.install(*songs)
      @songs = SongUtils.get_songs
      @local_songs = SongUtils.get_local_songs

      if songs.length > 0
        songs.each do |song|
          name = SongUtils.parse_song_name song
          begin
            version = Semver.new(SongUtils.parse_song_version song)
          rescue 
            version = false
          end
          url = @songs[name]['url']
          path = "bowie_songs/#{name}"

          if File.directory? path
            self.update(name)
          else
            FileUtils.mkdir_p(path)
            Git.clone(url, path)
            if version
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
            version ? @local_songs.push(name+'#'+version.to_s) : @local_songs.push(name)
          end
          File.open("songs.yml", "w"){|f| YAML.dump(@local_songs, f)}
        end
      else
        @local_songs.each {|song| self.install(song)}
      end
    end
  end
end