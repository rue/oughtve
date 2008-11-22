module Oughtve

  class Verse
    include DataMapper::Resource

    # Unique identifier
    property    :id,      Serial

    # Note text
    property    :text,    Text,     :nullable => false

    # Time at which entered (approximately anyway)
    property    :time,    Time,     :nullable => false


    # We know nothing about no Tangents
    belongs_to  :chapter

  end

end
