describe "Bowie::Actions.search" do
  it "search [song]" do
    expect {Bowie::Actions.search('susy')}.not_to be_nil
    expect {Bowie::Actions.search('susy')['susy']}.not_to be_nil
  end

  it "search with no arguments" do
    expect {Bowie::Actions.search()}.to raise_error
  end

  it "search with more than 1 argument" do
    expect {Bowie::Actions.search('foo', 'bar', 'baz')}.to raise_error
  end

  subject(:query) {Bowie::Actions.search('susy')['susy']}
  it "returns expected results" do
    query['name'].should eq "susy"
    query['description'].should eq "A responsive grid framework for Compass"
    query['url'].should eq "https://github.com/ericam/susy"
  end
end