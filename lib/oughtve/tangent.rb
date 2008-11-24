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


module Oughtve

  # Forward-declare Chapter.
  class Chapter; end


  #
  # Tangents are directory-based groupings of notes.
  #
  class Tangent
    include DataMapper::Resource

    # Unique identifier
    property  :id,      Serial

    # Base directory in which this Tangent lives
    property  :dir,     String,   :nullable => false

    # Name by which the Tangent can be accessed
    property  :name,    String,   :nullable => false


    # Currently active Chapter
    has 1,    :current_chapter,   :class_name => "Chapter"

    # Previous Chapters
    has n,    :chapters
  end


  # The standard time format
  TimeFormat = "%Y-%m-%d %H:%M:%S"


  #
  # Enter a new Verse.
  #
  def self.scribe(parameters)
    text = parameters.text || ""
    text << " " << parameters.rest.join(" ") unless parameters.rest.empty?

    raise ArgumentError, "No note!" if text.empty?

    tangent = tangent_for parameters

    verse = Verse.new :text => text, :time => parameters.time

    tangent.current_chapter.verses << verse
    tangent.save
  end


  #
  # Output notes for tangent
  #
  def self.show(parameters)
    tangent = tangent_for parameters

    tangent.current_chapter.verses.map {|v|
      if parameters.verbose
        " - #{v.text} (#{v.time.strftime TimeFormat})"
      else
        " - #{v.text}"
      end
    }.join "\n"
  end


  #
  # Strike out an existing note.
  #
  # Used to mark a note completed (or just get rid of it.)
  #
  def self.strike(parameters)
    verse = if parameters.serial
              Verse.get! parameters.serial
            else
              tangent = tangent_for parameters
              candidates =  tangent.current_chapter.verses.select {|v|
                              parameters.regexp =~ v.text
                            }

              if candidates.size < 1
                raise ArgumentError, "No match for #{parameters.regexp.inspect}!"
              elsif candidates.size > 1
                # TODO: Show matches
                raise ArgumentError, "Ambiguous #{parameters.regexp.inspect}!"
              end

              candidates.first
            end

    raise ArgumentError, "Already stricken: #{parameters.serial}" if verse.stricken

    verse.stricken = parameters.time
    verse.save
  end


  #
  # Create a new Tangent.
  #
  def self.tangent(parameters)
    tangent = Tangent.new

    tangent.dir = File.expand_path(parameters.dir) rescue Dir.pwd
    raise ArgumentError, "No such directory #{tangent.dir}" unless File.directory? tangent.dir

    tangent.name = parameters.name || tangent.dir
    tangent.current_chapter = Chapter.new

    tangent.save
  end


  private

  #
  # Locate Tangent matching given directory closest.
  #
  def self.tangent_for(parameters)
    return Tangent.first :name => parameters.name if parameters.name

    dir = if parameters.dir then File.expand_path(parameters.dir) else Dir.pwd end

    Tangent.all.inject {|longest, t|
      if /\A#{Regexp.escape t.dir}/ =~ dir and t.dir.size > longest.dir.size
        t
      else
        longest
      end
    }
  end

end
