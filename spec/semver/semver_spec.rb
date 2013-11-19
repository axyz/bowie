require 'rspec'
require './lib/semver/semver'

describe Semver do

  context "when valid #semver in x.x.x form" do
    it "initialize without errors" do
      expect {Semver.new "1.2.3"}.to_not raise_error
    end

    subject(:version) {Semver.new "1.2.3"}
    it "initialize correctly major, minor and patch parameters" do
      expect(version.major).to be 1
      expect(version.minor).to be 2
      expect(version.patch).to be 3
    end
  end

  context "when valid #semver in vx.x.x form" do
    it "initialize without errors" do
      expect {Semver.new "v1.2.3"}.to_not raise_error
    end

    subject(:version) {Semver.new "v1.2.3"}
    it "initialize correctly major, minor and patch parameters" do
      expect(version.major).to be 1
      expect(version.minor).to be 2
      expect(version.patch).to be 3
    end
  end

  context "when initialized with invalid semver string" do
    it "raise invalid semver error" do
      expect {Semver.new "v1.2.3.4"}.to raise_error "invalid semver"
    end
  end

  context "when initialized with too mani arguments" do
    it "raise ArgumentError" do
      expect {Semver.new "v1.2.3", "foo"}.to raise_error ArgumentError
    end
  end

end