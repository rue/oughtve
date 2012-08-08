require "fileutils"

# Project
require "oughtve/errors"
require "oughtve/options"


module Oughtve

  #
  # Directory in which our resources are stored. Just in $HOME for now.
  #
  ResourceDirectory  = File.expand_path File.join(ENV["HOME"], ".oughtve")


  #
  # Entry point to the library.
  #
  # Parses arguments and performs the requested action.
  #
  def self.run(arguments)
    options = parse_from arguments

    Database.connect and self.send options.action, options
  end


  #
  # Bootstrap a brand new setup.
  #
  def self.bootstrap(*)
    FileUtils.mkdir_p ResourceDirectory and Database.bootstrap
    run %w[ --new --tangent default --directory / ]

    "Oughtve has been set up. A default tangent has been created."
  end

end

require "oughtve/database"

