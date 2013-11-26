require 'bowie/song_utils'

Dir.glob('./lib/bowie/actions/*') do |action|
  require action
end