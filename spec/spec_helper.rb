# Ensure this current set is before any installed ones
#
$LOAD_PATH.unshift "#{File.dirname(__FILE__)}/../lib"

require "oughtve"

require "minitest/autorun"

require "database_cleaner"
require "dm-transactions"

require "fakefs/safe"

# Hide some warnings explicitly.
#
def silently()
  $VERBOSE, old_verbose = nil, $VERBOSE

  yield
  
ensure
  $VERBOSE = old_verbose
end


DatabaseCleaner.strategy = :transaction

class MiniTest::Spec
  before :each do
    test_db = "sqlite3::memory:"

    silently { Oughtve::Database::URI = test_db }
    DataMapper::Logger.new(STDOUT, :debug) if $VERBOSE
    DataMapper.setup :default, test_db

    DatabaseCleaner.start
  end

  after :each do
    DatabaseCleaner.clean
  end
end

