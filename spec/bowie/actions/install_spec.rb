describe "Bowie::Actions" do
  it ".install [song]" do
    expect {Bowie::Actions.install('bowie-test')}.to_not raise_error
    expect(File.directory? './bowie_songs').to be true
    expect(File.directory? './bowie_songs/bowie-test').to be true
    expect(File.exist? './songs.yml').to be true
    expect(Bowie::SongUtils.get_local_songs.include? 'bowie-test').to be true
    expect(Bowie::SongUtils.get_local_songs.length).to be 1
  end

  context "when songs.yml exist" do
    before(:each) do
      File.open("./songs.yml", "w"){|f| YAML.dump(["bowie-test"], f)}
    end
    after(:each) do
      FileUtils.rm_rf('./songs.yml')
    end

    it "install with no argument" do
      expect {Bowie::Actions.install()}.to_not raise_error
      expect(File.directory? './bowie_songs').to be true
      expect(File.directory? './bowie_songs/bowie-test').to be true
      expect(File.exist? './songs.yml').to be true
      expect(Bowie::SongUtils.get_local_songs.include? 'bowie-test').to be true
      expect(Bowie::SongUtils.get_local_songs.length).to be 1
    end
  end

  context "when songs.yml do not exist" do
    it "install with no argument" do
      expect {Bowie::Actions.install()}.to_not raise_error
      expect(File.directory? './bowie_songs').to be true
      expect(File.directory? './bowie_songs/bowie-test').to be false
      expect(File.exist? './songs.yml').to be true
      expect(Bowie::SongUtils.get_local_songs.include? 'bowie-test').to be false
      expect(Bowie::SongUtils.get_local_songs.length).to be 0
    end
  end

  context "when songs.yml is not valid" do
    before(:each) do
      h = Hash.new
      h['bowie-test'] = '0.0.1'
      File.open("./songs.yml", "w"){|f| YAML.dump(h, f)}
    end
    after(:each) do
      FileUtils.rm_rf('./songs.yml')
    end

    it "install with no argument" do
      expect {Bowie::Actions.install()}.to raise_error "songs.yml is not valid"
      expect(File.directory? './bowie_songs').to be false
      expect(File.directory? './bowie_songs/bowie-test').to be false
      expect(File.exist? './songs.yml').to be true
      expect(Bowie::SongUtils.valid_songs_file? './songs.yml').to be false
    end
  end
end