describe "Bowie::Actions" do
  context "when the song is installed" do
    before(:each) do
      Bowie::Actions.install 'bowie-test'
    end
    after(:each) do
      Bowie::Actions.uninstall 'bowie-test'
    end
    
    it ".get" do
      expect {Bowie::Actions.get('bowie-test', 'foo')}.to_not raise_error
    end
  end

  context "when the song is not installed" do    
    it ".get" do
      expect {Bowie::Actions.get('bowie-test', 'foo')}.to raise_error "song not installed"
    end
  end
end