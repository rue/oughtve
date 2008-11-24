#  LICENCE
# =========
#
#  Authors
# ---------
#
#   See doc/AUTHORS.
#
#
#  Copyright
# -----------
#
#   Copyright (c) 2006-2008 Eero Saynatkari, all rights reserved.
#
#
#  Licence
# ---------
#
#   Redistribution and use in source and binary forms, with or without
#   modification, are permitted provided that the following conditions
#   are met:
#
#   - Redistributions of source code must retain the above copyright
#     notice, this list of conditions, the following disclaimer and
#     attribution to the original authors.
#
#   - Redistributions in binary form must reproduce the above copyright
#     notice, this list of conditions, the following disclaimer and
#     attribution to the original authors in the documentation and/or
#     other materials provided with the distribution.
#
#   - The names of the authors may not be used to endorse or promote
#     products derived from this software without specific prior
#     written permission.
#
#
#  Disclaimer
# ------------
#
#   This software is provided "as is" and without any express or
#   implied warranties, including, without limitation, the implied
#   warranties of merchantability and fitness for a particular purpose.
#   Authors are not responsible for any damages, direct or indirect.
#

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

    Database.connect and self.send options.action, options
  end

  #
  # Bootstrap a brand new bootstrap.
  #
  def self.bootstrap(*)
    FileUtils.mkdir_p ResourceDirectory and Database.bootstrap
    run %w[ --new --tangent default --directory / ]

    "Oughtve has been set up. A default tangent has been created."
  end


end

require "oughtve/database"

