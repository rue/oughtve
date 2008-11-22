
require "fileutils"
require "tmpdir"

# We do not want spec_helper since we must check the setup here.
$LOAD_PATH << "#{File.dirname __FILE__}/../lib"
require "oughtve"


describe Oughtve, "initial setup using --setup" do

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

  it "creates a Sqlite database ~/.oughtve/db" do
    File.exist?(Oughtve::Database::Path).should == false

    Oughtve.run %w[ setup ]

    File.exist?(Oughtve::Database::Path).should == true
  end

end
