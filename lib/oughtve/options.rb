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
#   Copyright (c) 2006-2009 Eero Saynatkari, all rights reserved.
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

require "optparse"
require "ostruct"


# Project
require "oughtve/version"


module Oughtve

  #
  # Parse allowed options from given arguments
  #
  def self.parse_from(arguments)
    result = OpenStruct.new

    # Grab time here to be a bit closer to true
    result.time = Time.now

    def result.action!(given)
      raise ArgumentError, "Two actions given: 1) --#{action}, 2) --#{given}" if action
      self.action = given
    end

    OptionParser.new do |opts|

      opts.banner = "Usage: #{$0} [--ACTION [OPTIONS]]"

      opts.separator ""
      opts.separator "  Use `#{$0} --help ACTION` for more help."

      opts.separator ""
      opts.separator "  Actions:"


      # Actions

      opts.on "-b", "--bootstrap", "Set up database and initial structures." do
        result.action! :bootstrap
      end

      opts.on "-c", "--chapter ENDNOTE", "Mark end of chapter and start new one." do |endnote|
        result.action! :chapter
        result.endnote = endnote
      end

      opts.on "-l", "--list", "Show defined Tangents and their base directories." do
        result.action! :list
      end

      opts.on "-n", "--new", "Create new Tangent." do
        result.action! :tangent
      end

      opts.on "-s", "--scribe [TEXT]", "Enter a new note." do |text|
        result.action! :scribe
        result.text = text
      end

      opts.on "-w", "--show", "Show notes for tangent(s)." do
        result.action! :show
      end

      opts.on "-S", "--strike [ID_OR_REGEXP]", "Strike out a note." do |id_or_regexp|
        result.action! :strike

        if id_or_regexp
          begin
            result.serial = Integer(id_or_regexp)
          rescue TypeError
            result.regexp = /#{Regexp.escape id_or_regexp}/
          end
        end
      end


      # Options
      opts.separator ""
      opts.separator "  Options:"

      opts.on "-d", "--directory DIR", "Use given directory instead of Dir.pwd." do |dir|
        result.dir = dir
      end

      opts.on "-i", "--id ID", "Use specific note ID." do |id|
        result.serial = id
      end

      opts.on "-m", "--match REGEXP", "Match note using regexp, specific branch only." do |regexp|
        result.regexp = /#{Regexp.escape regexp}/
      end

      opts.on "-t", "--tangent NAME", "Use named Tangent specifically." do |name|
        result.name = name
      end

      opts.on "-x", "--text TEXT", "Text to use for note." do |text|
        result.text = text
      end

      opts.on "-v", "--verbose", "Give extra information for some actions." do
        result.verbose = true
      end


      # Bookkeeping stuff

      opts.on_tail "-h", "--help", "Display this message." do
        puts opts
        exit
      end

      opts.on_tail "-V", "--version", "Display Oughtve version" do
        puts
        puts "        Oughtve version #{Oughtve::VERSION.join(".")}."
        puts "Copyright (c) 2006-2009 Eero Saynatkari."
        puts
        exit
      end

    end.parse! arguments

    result.rest = arguments
    result.action = :scribe unless result.action
    result
  end

end
