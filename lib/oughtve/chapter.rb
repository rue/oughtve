
module Oughtve

  # Forward-declare Tangent
  class Tangent; end


  #
  # A Chapter is a (hopefully) logical section of a Tangent.
  #
  class Chapter
    include DataMapper::Resource

    # Unique identifier
    property    :id,          Serial

    # Time when closed
    property    :ended,       Time

    # Summary of what the chapter was about
    property    :summary,     Text


    has n, :verses
    belongs_to :tangent


    #
    # Hash representation of data, including all verses.
    #
    def to_hash()
      closed, open = verses.partition {|verse| verse.struck }
      hash = {:open => open.map {|v| v.to_hash },
              :closed => closed.map {|v| v.to_hash }
             }

      if ended
        hash[:ended] = ended
        hash[:summary] = summary
      end

      hash
    end

  end

end

