describe "Bowie::Actions" do
  it ".search [song]" do
    expect {Bowie::Actions.search('bowie-test')}.not_to be_nil
    expect {Bowie::Actions.search('bowie-test')['bowie-test']}.not_to be_nil
  end

  it ".search with no arguments" do
    expect {Bowie::Actions.search()}.to raise_error(ArgumentError)
  end

  it ".search with more than 1 argument" do
    expect {Bowie::Actions.search('foo', 'bar', 'baz')}.to raise_error(ArgumentError)
  end

  subject(:query) {Bowie::Actions.search('bowie-test')['bowie-test']}
  it ".search returns expected results" do
    expect(query['name']).to match "bowie-test"
    expect(query['description']).to match "A repository for Bowie testing"
    expect(query['url']).to match "https://github.com/axyz/bowie-test"
  end
end