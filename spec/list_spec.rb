require_relative "./spec_helper"

describe Oughtve, "listing defined tangents" do

  before :each do
    Oughtve.bootstrap
    Oughtve.run %w[ --new --tangent tangy --directory /tmp ]
  end

  it "shows name and base directory of each tangent in the system" do
    outputs = Oughtve.run(%w[ --list ]).split "\n"

    # First line is a banner
    outputs.shift
    outputs.shift

    line = outputs.shift
    line.must_match /default/
    line.must_match /\//

    line = outputs.shift
    line.must_match /tangy/
    line.must_match /\/tmp/
  end

end
