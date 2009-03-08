require File.join File.dirname(__FILE__), "spec_helper"

describe Oughtve, "listing defined tangents" do

  before :all do
    Oughtve.run %w[ --new --tangent tangy --directory /tmp ]
  end

  it "shows name and base directory of each tangent in the system" do
    outputs = Oughtve.run(%w[ --list ]).split "\n"

    # First line is a banner
    outputs.shift
    outputs.shift

    line = outputs.shift
    line.should =~ /default/
    line.should =~ /\//

    line = outputs.shift
    line.should =~ /tangy/
    line.should =~ /\/tmp/
  end

end
