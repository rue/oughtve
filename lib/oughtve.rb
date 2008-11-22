require "fileutils"

# Project
require "oughtve/errors"
require "oughtve/options"


module Oughtve

  #
  # Directory in which our resources are stored.
  #
  ResourceDirectory  = File.expand_path File.join(ENV["HOME"], ".oughtve")


  #
  # Entry point to the library.
  #
  # Parses arguments and performs the requested action.
  #
  def self.run(arguments)
    options = parse_from arguments

    self.send options.action, options
  end

  #
  # Bootstrap a brand new setup.
  #
  def self.setup(*)
    FileUtils.mkdir_p ResourceDirectory and Database.setup
  end


end

require "oughtve/database"

