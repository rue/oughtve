require File.join File.dirname(__FILE__), "spec_helper"

describe Oughtve, "listing defined tangents" do

  before :all do
    Oughtve.run %w[ --new --tangent tangy --directory /tmp ]
  end

  it "shows name and base directory of each tangent in the system" do
    outputs = Oughtve.run(%w[ --list ]).split "\n"

    outputs.size.should == 3

    # First line is a banner

    outputs[1].should =~ /default/
    outputs[1].should =~ /\//

    outputs[2].should =~ /tangy/
    outputs[2].should =~ /\/tmp/
  end

end
