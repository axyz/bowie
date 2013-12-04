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

  context "when a song is correctly installed" do
    before(:each) do
      Bowie::Actions.install 'bowie-test'
    end
    after(:each) do
      Bowie::Actions.uninstall 'bowie-test'
    end

    it ".installed_song?" do
      expect {Bowie::SongUtils.installed_song? 'bowie-test'}.to_not raise_error
      expect(Bowie::SongUtils.installed_song? 'bowie-test').to be true
    end
  end

  context "when a song is not installed" do
    it ".installed_song?" do
      expect {Bowie::SongUtils.installed_song? 'bowie-test'}.to_not raise_error
      expect(Bowie::SongUtils.installed_song? 'bowie-test').to be false
    end
  end

  context "when a song is not correctly installed" do
    before(:each) do
      Bowie::Actions.install 'bowie-test'
      FileUtils.rm_rf('./songs.yml')
    end
    after(:each) do
      Bowie::Actions.uninstall 'bowie-test'
    end

    it ".installed_song?" do
      expect {Bowie::SongUtils.installed_song? 'bowie-test'}.to_not raise_error
      expect(Bowie::SongUtils.installed_song? 'bowie-test').to be false
    end
  end

  context "when .bowierc exist and is valid" do
    before(:each) do
      h = Hash.new
      h["bowie-dir"] = "foo"
      File.open("./.bowierc", "w"){|f| YAML.dump(h, f)}
    end
    after(:each) do
      FileUtils.rm_rf('./.bowierc')
    end

    it ".valid_songs_file?" do
      expect {Bowie::SongUtils.get_bowie_dir}.to_not raise_error
      expect(Bowie::SongUtils.get_bowie_dir).to match "foo"
    end
  end

  context "when .bowierc exist and is not valid" do
    before(:each) do
      h = Hash.new
      h["bowie"] = "foo"
      File.open("./.bowierc", "w"){|f| YAML.dump(h, f)}
    end
    after(:each) do
      FileUtils.rm_rf('./.bowierc')
    end

    it ".valid_songs_file?" do
      expect {Bowie::SongUtils.get_bowie_dir}.to_not raise_error
      expect(Bowie::SongUtils.get_bowie_dir).to match "bowie_songs"
    end
  end

  context "when .bowierc do not exist" do
    it ".valid_songs_file?" do
      expect {Bowie::SongUtils.get_bowie_dir}.to_not raise_error
      expect(Bowie::SongUtils.get_bowie_dir).to match "bowie_songs"
    end
  end

end