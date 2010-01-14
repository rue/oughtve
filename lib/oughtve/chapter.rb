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
#   Copyright (c) 2006-2010 Eero Saynatkari, all rights reserved.
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
    property    :ended,       Time,     :default => nil

    # Summary of what the chapter was about
    property    :summary,     Text,     :default => nil


    belongs_to  :tangent
    has n,      :verses


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

