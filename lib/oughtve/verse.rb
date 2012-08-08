
module Oughtve

  #
  # A Verse is a single note or entry.
  #
  class Verse
    include DataMapper::Resource

    # Unique identifier
    property    :id,        Serial

    # Time at which entered (approximately anyway)
    property    :time,      DateTime, :required => true

    # Note text
    property    :text,      Text,     :required => true

    # Whether struck out (done) and time of occurrence if so
    property    :struck,    DateTime


    # We know nothing about no Tangents
    belongs_to  :chapter


    #
    # Hash representation of data.
    #
    def to_hash()
      hash = {:text => text, :time => time}
      hash[:closed] = struck if struck
      hash
    end

  end

end
