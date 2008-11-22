
require "fileutils"
require "tmpdir"

# We do not want spec_helper since we must check the setup here.
$LOAD_PATH << "#{File.dirname __FILE__}/../lib"
require "oughtve"


describe Oughtve, "initial setup" do

  before :all do
    # Delete the dir created by the spec runner to simplify
    FileUtils.rm_r ENV["HOME"], :secure => true
  end

  before :each do
    $VERBOSE, @verbose = nil, $VERBOSE
    FileUtils.mkdir_p ENV["HOME"]
  end

  after :each do
    FileUtils.rm_r ENV["HOME"], :secure => true
    $VERBOSE = @verbose
  end


# Behaviour

  it "raises an error if a database file already exists" do
    FileUtils.mkdir_p File.dirname(Oughtve::Database::Path)
    FileUtils.touch Oughtve::Database::Path

    lambda { Oughtve.run %w[ setup ] }.should raise_error(OughtveError)
  end

end
