Mixplay

Setup
1. If Ruby is not installed, please run brew install ruby
2. Run git clone https://github.com/jessiezhang2017/mixplay.git
3. cd into mixplay
4. Run gem install bundler if you do not have bundler installed
5. Run bundle install to install ruby dependencies
6. Run rake test to verify all tests are passing

run program
1. cd into lib folder
2. cd into file folder , save the mixtape.json (input) and changes.json (changes)
2. Run ruby processor.rb mixtape.json changes.json result.json

check result
1. cd into file folder
2. result.json is the required result file (output)

assumptions
1. assume one user can have only have one playlist
2. all the info in mixtape.json are valid

what changes would need to make in order to scale this application to handle very large input files and/or very large changes files?

Can add a database to the program, save the data read from input file / changes file to  a database instead of save it to a hash or a map in the memory.

Can split the one big file into small files, make one file only deal with one class of data input / data change.

Instead of using File.read, which will pull in all the data of the file and save to a variable,  can use File.open. It will  give you a chance to read the file line by line or read a small portion each time.
