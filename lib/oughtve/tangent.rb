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
  # Most of the work occurs here. Chapters and Verses
  # are mere extras on this stage.
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

    #
    # Hash representation, including all Verses.
    #
    def to_hash()
      {
       :name => name,
       :dir => dir,
       :current => current_chapter.to_hash,
       :old => chapters.sort_by {|c| c.ended || Time.now }.reverse.map {|c| c.to_hash}
      }
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
  # Delete a tangent.
  #
  # @todo Does not touch Chapters or Verses.
  #
  def self.delete(parameters)
    raise ArgumentError, "Must provide name to delete!" unless parameters.name
    raise ArgumentError, "Default tangent may not be deleted!" if parameters.name == "default"

    tangent = tangent_for parameters

    raise ArgumentError, "No tangent named `#{parameters.name}'!" unless tangent

    tangent.destroy
  end


  #
  # Show all open defined Tangents and their base directories.
  #
  def self.list(*)
    " Defined tangents:\n" <<
    "===================\n" <<
    Tangent.all.map {|t| " * #{t.name} (#{t.dir})" }.join("\n")
  end


  #
  # Enter a new Verse.
  #
  # Text may be given with or without --text option, or
  # read from $stdin if no other text is found.
  #
  def self.scribe(parameters)
    tangent = tangent_for parameters

    text = parameters.text || ""
    text << " " << parameters.rest.join(" ") unless parameters.rest.empty?

    if text.empty?
      $stdout.puts "Reading for `#{tangent.name}' from standard input, terminate with ^D."
      text = $stdin.read
    end

    raise ArgumentError, "No note!" if text.empty?

    tangent.current_chapter.verses.build(:text => text.strip, :time => parameters.time).save

    "So noted in \"#{tangent.name}\"."
  end


  #
  # Output notes for tangent.
  #
  # Optionally both open and closed; optionally old chapters too.
  #
  def self.show(parameters)
    tangent = tangent_for parameters

    case parameters.format
    when :yaml
      require "yaml"
      return tangent.to_hash.to_yaml
    when :json
      require "json"
      return tangent.to_hash.to_json
    end

    message = " #{tangent.name}\n"
    message << ("=" * (tangent.name.length + 2)) << "\n"

    chapters = if parameters.old
                 tangent.chapters.sort_by {|chapter| chapter.ended || Time.now }.reverse
               else
                 [tangent.current_chapter]
               end

    chapters.each {|chapter|
      if chapter.summary
        summary = "#{chapter.summary}, closed #{chapter.ended.strftime TimeFormat}"
        message << "\n\n\n" << summary << "\n" << ("=" * (summary.length + 2)) << "\n"
      end

      closed, open = chapter.verses.partition {|v| v.stricken }

      # @todo Remove duplication here, unless output stays different..
      message << "\n Open:\n-------\n"
      message <<  open.reverse.map {|v|
                    if parameters.verbose
                      " * #{v.text} (##{v.id} #{v.time.strftime TimeFormat})"
                    else
                      " * #{v.text}"
                    end
                  }.join("\n")

      message << "\n\n Closed:\n---------\n"
      message <<  closed.reverse.map {|v|
                    if parameters.verbose
                      " * #{v.text} (##{v.id} #{v.time.strftime TimeFormat})"
                    else
                      " * #{v.text}"
                    end
                  }.join("\n")
    }

    message
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
    dir = File.expand_path(parameters.dir) rescue Dir.pwd

    tangent = tangent_for parameters, :check_path_too

    if tangent
      if tangent.name == parameters.name
        raise ArgumentError, "Tangent `#{tangent.name}' already exists at #{tangent.dir}"
      end

      # Relationship with existing tangent?
      case dir <=> tangent.dir
      when -1
        # @todo Is this a necessary warning? Verbose only maybe? --rue
        warn "One or more existing tangents live below the new one (at least #{tangent.dir})"
      when 0
        raise ArgumentError, "#{tangent.dir} is already bound to `#{tangent.name}'!"
      else
        # Does not matter if it is a subdirectory
      end
    end

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
  def self.tangent_for(parameters, check_path_too = false)

    # *sigh*
    if parameters.name
      named = Tangent.first :name => parameters.name

      if named
        if parameters.dir and named.dir != File.expand_path(parameters.dir)
          raise ArgumentError, "Given path #{parameters.dir} does not match named `#{named.name}' path #{named.dir}"
        end
        return named
      end

      return named unless check_path_too
    end

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
