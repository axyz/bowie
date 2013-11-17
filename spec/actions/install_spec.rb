describe "Bowie::Actions" do
  it ".install [song]" do
    expect {Bowie::Actions.install('bowie-test')}.to_not raise_error
    expect(File.directory? './bowie_songs').to be true
    expect(File.directory? './bowie_songs/bowie-test').to be true
    expect(File.exist? './songs.yml').to be true
    expect(Bowie::SongUtils.get_local_songs.include? 'bowie-test').to be true
    expect(Bowie::SongUtils.get_local_songs.length).to be 1
  end
end