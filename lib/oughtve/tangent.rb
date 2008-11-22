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
  # Create a new Tangent.
  #
  def self.tangent(parameters)
    tangent = Tangent.new

    tangent.dir   = File.expand_path(parameters.dir) rescue Dir.pwd
    raise ArgumentError, "No such directory #{tangent.dir}" unless File.directory? tangent.dir

    tangent.name  = parameters.name || tangent.dir
    tangent.current_chapter = Chapter.new

    tangent.save
  end

end
