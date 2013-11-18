describe "Bowie::SongUtils" do
  it ".parse_song_name" do
    expect {Bowie::SongUtils.parse_song_name 'bowie-test#0.0.1'}.to_not raise_error
    expect(Bowie::SongUtils.parse_song_name 'bowie-test#0.0.1').to match "bowie-test"
  end

  it ".parse_song_version" do
    expect {Bowie::SongUtils.parse_song_version 'bowie-test#0.0.1'}.to_not raise_error
    expect(Bowie::SongUtils.parse_song_version 'bowie-test#0.0.1').to match "0.0.1"
  end

  it ".valid_song?" do
    expect(Bowie::SongUtils.valid_song? 'bowie-test').to be true
    expect(Bowie::SongUtils.valid_song? 'bowie-test#0.0.1').to be true
    expect(Bowie::SongUtils.valid_song? '-foo-bar').to be false
    expect(Bowie::SongUtils.valid_song? 'foo-bar-').to be false
    expect(Bowie::SongUtils.valid_song? 'foo-bar-#0.0.1').to be false
    expect(Bowie::SongUtils.valid_song? 'foo-bar#0.1').to be false
    expect(Bowie::SongUtils.valid_song? 'foo-bar#0.1.2.3').to be false
  end

  context "when lyrics.yml is valid" do
    before(:each) do
      File.open("./lyrics.yml", "w"){|f| YAML.dump(Hash.new, f)}
    end
    after(:each) do
      FileUtils.rm_rf('./lyrics.yml')
    end
    
    it ".valid_lyrics_file?" do
      expect {Bowie::SongUtils.valid_lyrics_file? './lyrics.yml'}.to_not raise_error
      expect(Bowie::SongUtils.valid_lyrics_file? './lyrics.yml').to be true
    end
  end

  context "when lyrics.yml is not valid" do
    before(:each) do
      File.open("./lyrics.yml", "w"){|f| YAML.dump(Array.new, f)}
    end
    after(:each) do
      FileUtils.rm_rf('./lyrics.yml')
    end
    
    it ".valid_lyrics_file?" do
      expect {Bowie::SongUtils.valid_lyrics_file? './lyrics.yml'}.to_not raise_error
      expect(Bowie::SongUtils.valid_lyrics_file? './lyrics.yml').to be false
    end
  end

  context "when songs.yml is valid" do
    before(:each) do
      File.open("./songs.yml", "w"){|f| YAML.dump(["bowie-test", "foo", "bar"], f)}
    end
    after(:each) do
      FileUtils.rm_rf('./songs.yml')
    end

    it ".valid_songs_file?" do
      expect {Bowie::SongUtils.valid_songs_file? './songs.yml'}.to_not raise_error
      expect(Bowie::SongUtils.valid_songs_file? './songs.yml').to be true
    end
  end

  context "when songs.yml is not valid" do
    before(:each) do
      h = Hash.new
      h["bowie-test"] = ".0.1"
      h["susy"] = "0.0.1"
      File.open("./songs.yml", "w"){|f| YAML.dump(h, f)}
    end
    after(:each) do
      FileUtils.rm_rf('./songs.yml')
    end

    it ".valid_songs_file?" do
      expect {Bowie::SongUtils.valid_songs_file? './songs.yml'}.to_not raise_error
      expect(Bowie::SongUtils.valid_songs_file? './songs.yml').to be false
    end
  end

end