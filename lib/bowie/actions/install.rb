module Bowie
  module install
    def self.install(*songs)
      @songs = self.get_songs
      @local_songs = self.get_local_songs

      if songs.length > 0
        songs.each do |song|
          name = Utils.parse_song_name song
          version = Semver.new(Utils.parse_song_version song)
          url = @songs[name]['url']
          path = "bowie_songs/#{name}"

          if File.directory? path
            self.update(name)
          else
            FileUtils.mkdir_p(path)
            Git.clone(url, path)
            if version.major != nil
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
            version.major ? @local_songs.push(name+'#'+version.to_s) : @local_songs.push(name)
          end
          File.open("songs.yml", "w"){|f| YAML.dump(@local_songs, f)}
        end
      else
        @local_songs.each {|song| self.install(song)}
      end
    end
  end
end