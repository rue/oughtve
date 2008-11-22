module Oughtve

  # Forward-declare Tangent
  class Tangent; end


  class Chapter
    include DataMapper::Resource

    # Unique identifier
    property    :id,          Serial

    # Time when closed
    property    :closed_at,   DateTime,     :default => nil


    # Tangent to which this Chapter belongs (active or not)
    belongs_to  :tangent

  end

end

