require "rubygems"
require "dm-core"

require "oughtve/tangent"
require "oughtve/chapter"


module Oughtve

  #
  # Explicit database manipulations.
  #
  # The resources are managed through the resource
  # classes Tangent, Chapter and Verse.
  #
  module Database

    # The database file path.
    Path  = File.expand_path "#{Oughtve::ResourceDirectory}/data.db"

    # The full URI to access the DB.
    URI   = "sqlite3:///#{Path}"


    #
    # Connect to database (new or existing)
    #
    def self.connect()
      DataMapper.setup :default, URI
    end

    #
    # Create a brand-new database.
    #
    def self.setup()
      raise OughtveError, "#{Path} already exists!" if File.exist? Path

      connect and DataMapper.auto_migrate!

      Tangent.new(:dir => "/", :name => "default").save
    end

  end

end
