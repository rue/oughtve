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


  #
  # Enter a new Verse.
  #
  def self.scribe(parameters)
    text = parameters.text || parameters.rest.join(" ")
    raise ArgumentError, "No note!" if text.empty?

    tangent = if parameters.name
                Tangent.first :name => parameters.name
              else
                tangent_for parameters.dir || Dir.pwd
              end

    verse = Verse.new :text => text, :time => parameters.time

    tangent.current_chapter.verses << verse
    tangent.save
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
  def self.tangent_for(dir)
    Tangent.first :dir => File.expand_path(dir)
  end

end
