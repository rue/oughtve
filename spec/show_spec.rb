require File.join File.dirname(__FILE__), "spec_helper"

describe Oughtve, "listing notes given a tangent name" do

  before :each do
    Oughtve.run %w[ --new --tangent tangy --directory /tmp ]
    Oughtve.run %w[ --scribe --tangent tangy Hi bob! ]
    Oughtve.run %w[ --scribe --tangent tangy Hi Mike! ]
    Oughtve.run %w[ --scribe --tangent tangy Hi james! ]
  end

  after :each do
    Oughtve::Tangent.all(:name.not => "default").each {|t| t.destroy }
  end

  it "raises if named tangent cannot be found" do
    Oughtve::Tangent.all.size.should == 2

    lambda { Oughtve.run %w[  --show --tangent nonesuch ] }.should raise_error
  end
end

describe Oughtve, "listing notes without output options" do

  before :each do
    Oughtve.run %w[ --new --tangent tangy --directory /tmp ]
    Oughtve.run %w[ --scribe --tangent tangy Hi bob! ]
    Oughtve.run %w[ --scribe --tangent tangy Hi Mike! ]
    Oughtve.run %w[ --scribe --tangent tangy Hi james! ]
  end

  after :each do
    Oughtve::Tangent.all(:name.not => "default").each {|t| t.destroy }
  end

  it "produces a string containing text for all open notes for tangent" do
    outputs = Oughtve.run(%w[ --show --tangent tangy ]).split "\n"

    outputs[0].should =~ /Hi bob!/
    outputs[1].should =~ /Hi Mike!/
    outputs[2].should =~ /Hi james!/
  end

end

describe Oughtve, "listing notes with --verbose" do

  before :each do
    Oughtve.run %w[ --new --tangent tangy --directory /tmp ]
    Oughtve.run %w[ --scribe --tangent tangy Hi bob! ]
    Oughtve.run %w[ --scribe --tangent tangy Hi Mike! ]
    Oughtve.run %w[ --scribe --tangent tangy Hi james! ]
  end

  after :each do
    Oughtve::Tangent.all(:name.not => "default").each {|t| t.destroy }
  end

  it "includes time when note was scribed" do
    outputs = Oughtve.run(%w[ --show --tangent tangy --verbose ]).split "\n"
    verses = Oughtve::Tangent.all(:name.eql => "tangy").current_chapter.verses

    outputs[0].should =~ /Hi bob!/
    outputs[0].should =~ /##{verses[0].id}/
    Time.parse(outputs[0].match(/\d\d\d\d-\d\d-\d\d \d\d:\d\d:\d\d/)[0]).to_i.should == verses[0].time.to_i

    outputs[1].should =~ /Hi Mike!/
    outputs[1].should =~ /##{verses[1].id}/
    Time.parse(outputs[1].match(/\d\d\d\d-\d\d-\d\d \d\d:\d\d:\d\d/)[0]).to_i.should == verses[1].time.to_i

    outputs[2].should =~ /Hi james!/
    outputs[2].should =~ /##{verses[2].id}/
    Time.parse(outputs[2].match(/\d\d\d\d-\d\d-\d\d \d\d:\d\d:\d\d/)[0]).to_i.should == verses[2].time.to_i
  end
end

describe Oughtve, "listing notes" do

  before :each do
    Oughtve.run %w[ --new --tangent tangy --directory /tmp ]
    Oughtve.run %w[ --scribe --tangent tangy Hi bob! ]
    Oughtve.run %w[ --scribe --tangent tangy Hi Mike! ]
    Oughtve.run %w[ --scribe --tangent tangy Hi james! ]
    Oughtve.run %w[ --strike --tangent tangy --match Hi\ j ]
  end

  after :each do
    Oughtve::Tangent.all(:name.not => "default").each {|t| t.destroy }
  end

  it "does not show stricken notes" do
    outputs = Oughtve.run(%w[ --show --tangent tangy ]).split "\n"

    outputs.size.should == 2

    outputs[0].should =~ /Hi bob!/
    outputs[1].should =~ /Hi Mike!/
  end
end
