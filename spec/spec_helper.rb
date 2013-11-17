RSpec.configure do |config|
  config.before(:each) do
    FileUtils.rm_rf('./bowie_songs')
    FileUtils.rm_rf('./songs.yml')
  end
  config.after(:each) do
    FileUtils.rm_rf('./bowie_songs')
    FileUtils.rm_rf('./songs.yml')
  end
end