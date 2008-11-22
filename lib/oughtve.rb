require "fileutils"


#
# Oughtve is non-instantiable.
#
# Most component-specific methods, such as Oughtve.tangent,
# are implemented in those files. Similarly, the help info
# for those methods can be found there.
#
module Oughtve

  #
  # Directory in which our resources are stored.
  #
  ResourceDirectory  = File.expand_path File.join(ENV["HOME"], ".oughtve")


  #
  # Entry point to the library.
  #
  # Parses arguments and initiates the requested action.
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
require "oughtve/errors"
require "oughtve/options"

