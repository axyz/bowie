describe "Bowie::Actions" do
  it ".get" do
    expect {Bowie::Actions.get('bowie-test', 'foo')}.to_not raise_error
  end
end