require "git"

module Bowie
  module Utils

    def self.get_git_tags(path)
      result = Array.new
      g = Git.open(path)
      g.tags.each do |tag|
        result.push tag.name
      end
      return result
    end

  end
end