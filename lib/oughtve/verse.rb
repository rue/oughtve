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

  #
  # A Verse is a single note or entry.
  #
  class Verse
    include DataMapper::Resource

    # Unique identifier
    property    :id,        Serial

    # Time at which entered (approximately anyway)
    property    :time,      Time,     :required => true

    # Note text
    property    :text,      Text,     :required => true

    # Whether struck out (done) and time of occurrence if so
    property    :struck,    Time


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
