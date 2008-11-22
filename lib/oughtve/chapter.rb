module Oughtve

  # Forward-declare Tangent
  class Tangent; end


  class Chapter
    include DataMapper::Resource

    # Unique identifier
    property    :id,          Serial

    # Time when closed
    property    :closed_at,   DateTime,     :default => nil


    belongs_to  :tangent
    has n, :verses

  end

end

