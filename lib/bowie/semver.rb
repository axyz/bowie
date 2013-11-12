module Semver
  # read a version string in the form x.x.x or vx.x.x and always return it in the form x.x.x
  def self.parse_version(string)
    string[0] == "v" ? string[1..-1] : string
  end
end