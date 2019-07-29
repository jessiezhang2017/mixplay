require_relative './lib/mixplay'

puts "welcome to playlist processor"

# initialize a new MixPlayManager object, passing three params, which are the names of original json file, changes json file and result json file
MixplayManager.new(ARGV[0], ARGV[1], ARGV[2])
