require "rubygems"
require "dm-core"

module Oughtve

  class Tangent
    include DataMapper::Resource

    # Unique identifier
    property  :id,      Serial

    # Base directory in which this Tangent lives
    property  :dir,     String,   :nullable => false

    # Name by which the Tangent can be accessed
    property  :name,    String,   :nullable => false

  end


  #
  # Create a new Tangent.
  #
  def self.tangent(parameters)
    tangent = Tangent.new
    tangent.dir   = parameters.dir || Dir.pwd
    tangent.name  = parameters.name || tangent.dir
    tangent.save
  end

end
