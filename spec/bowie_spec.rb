require 'rspec'
require './lib/bowie'
require './spec/spec_helper.rb'

describe "Bowie" do
  it "executes actions" do
    Dir.glob('./spec/bowie/actions/*') do |spec|
      require spec
    end
  end
end