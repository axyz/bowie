class Semver
  include Comparable

  attr_reader :major, :minor, :patch

  def initialize *s
    case s.length
    when 0
      @major = 0
      @minor = 0
      @patch = 0
    when 1
      if valid? s[0]
        v = (parse_version s[0]).split '.'
        @major = Integer v[0]
        @minor = Integer v[1]
        @patch = Integer v[2]
      else
        p 'error'
      end
    else
      p 'error'
    end
  end

  def to_s opts = {}
    opts[:v]? "v#{@major}.#{minor}.#{patch}" : "#{@major}.#{minor}.#{patch}"
  end

  def bump *type
    case type.length
    when 0
      @patch = @patch + 1
    when 1
      case type[0]
      when :major
        @major = @major + 1
      when :minor
        @minor = @minor + 1
      when :patch
        @patch = @patch + 1
      else
        p 'error'
      end
    else
      p 'error'
    end
  end

  def <=>(other)
    case self.major <=> other.major
    when 1
      return 1
    when -1
      return -1
    when 0
      case self.minor <=> other.minor
      when 1
        return 1
      when -1
        return -1
      when 0
        case self.patch <=> other.patch
        when 1
          return 1
        when -1
          return -1
        when 0
          return 0
        end
      end
    end
  end

private
    # read a version string in the form x.x.x or vx.x.x and always return it in the form x.x.x
    def parse_version(string)
      string[0] == "v" ? string[1..-1] : string
    end

    # return true if [string] is a valid semantic version in the form x.x.x or vx.x.x
    def valid?(string)
      (/^v?\d+.\d+.\d+$/ =~ string)? true : false
    end
end