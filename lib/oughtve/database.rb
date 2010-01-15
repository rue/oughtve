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
#   Copyright (c) 2006-2010 Eero Saynatkari, all rights reserved.
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

require "rubygems"
  require "dm-core"

require "oughtve/tangent"
require "oughtve/chapter"
require "oughtve/verse"


module Oughtve

  module Database

    # The database file path.
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
