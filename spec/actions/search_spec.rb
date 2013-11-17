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
    expect(query['name']).to match "susy"
    expect(query['description']).to match "A responsive grid framework for Compass"
    expect(query['url']).to match "https://github.com/ericam/susy"
  end
end