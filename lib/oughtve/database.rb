require "dm-core"
require "dm-migrations"

# Need these so that the tables can be defined.
#
require "oughtve/tangent"
require "oughtve/chapter"
require "oughtve/verse"


module Oughtve

  module Database

    # The database file path.
    #
    # TODO: Move into a config file for better testability.
    #
    Path  = File.expand_path "#{Oughtve::ResourceDirectory}/data.db"

    # The full URI to access the DB.
    URI   = "sqlite3:///#{Path}"


    #
    # Connect to database (new or existing)
    #
    def self.connect()
      DataMapper::Logger.new(STDOUT, :debug) if $VERBOSE
      DataMapper.setup :default, URI
    end

    #
    # Create a brand-new database.
    #
    def self.bootstrap()
      raise OughtveError, "#{Path} already exists!" if File.exist? Path
      connect and DataMapper.auto_migrate!
    end

  end

end
