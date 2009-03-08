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

    # Currently ongoing Chapter
    property  :current, Integer,  :nullable => false

    # Previous Chapters
    has n, :chapters


    def current_chapter()
      Chapter.get! self.current
    end

    def current_chapter=(chapter)
      self.current = chapter.id
      chapter.save
    end

  end


  # The standard time format
  TimeFormat = "%Y-%m-%d %H:%M:%S"


  #
  # Mark old chapter and start new one.
  #
  def self.chapter(parameters)
    tangent = tangent_for parameters
    previous = tangent.current_chapter

    previous.summary = parameters.endnote
    previous.summary << " " << parameters.rest.join(" ") unless parameters.rest.empty?

    previous.ended = parameters.time
    previous.save

    chapter = tangent.chapters.build
    chapter.save

    tangent.current_chapter = chapter
    tangent.save

    "Chapter of \"#{tangent.name}\" finished."
  end


  #
  # Show all open defined Tangents and their base directories.
  #
  def self.list(*)
    "Defined tangents:\n" << Tangent.all.map {|t| " - #{t.name} (#{t.dir})" }.join("\n")
  end


  #
  # Enter a new Verse.
  #
  # Text may be given with or without --text option, or
  # read from $stdin if no other text is found.
  #
  def self.scribe(parameters)
    text = parameters.text || ""
    text << " " << parameters.rest.join(" ") unless parameters.rest.empty?

    if text.empty?
      text = $stdin.read.chomp
    end

    raise ArgumentError, "No note!" if text.empty?

    tangent = tangent_for parameters
    tangent.current_chapter.verses.build(:text => text, :time => parameters.time).save

    "So noted (in \"#{tangent.name}\".)"
  end


  #
  # Output notes for tangent
  #
  def self.show(parameters)
    tangent = tangent_for parameters

    to_show = tangent.current_chapter.verses.reject {|v| v.stricken}

    to_show.map {|v|
      if parameters.verbose
        " - #{v.text} (##{v.id} #{v.time.strftime TimeFormat})"
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

    "\"#{verse.text[0..20]}...\" has been stricken."
  end


  #
  # Create a new Tangent.
  #
  def self.tangent(parameters)
    tangent = Tangent.new

    tangent.dir = File.expand_path(parameters.dir) rescue Dir.pwd
    raise ArgumentError, "No such directory #{tangent.dir}" unless File.directory? tangent.dir

    tangent.name = parameters.name || tangent.dir

    chapter = tangent.chapters.build
    chapter.save

    tangent.current_chapter = chapter
    tangent.save

    "Created #{tangent.name} at #{tangent.dir}."
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
