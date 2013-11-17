require 'rspec'
require './lib/bowie'
require './spec/spec_helper.rb'

describe "Bowie" do
  require './spec/bowie/song_utils_spec'
  Dir.glob('./spec/bowie/actions/*') do |spec|
    require spec
  end
end