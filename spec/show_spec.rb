require File.join File.dirname(__FILE__), "spec_helper"

describe Oughtve, "viewing notes given a tangent name" do

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

describe Oughtve, "viewing notes without output options" do

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
    outputs.reject! {|line| line.nil? or line.empty? or line.strip =~ /^(-|=)+$/ }

    outputs.shift.should =~ /tangy/
    outputs.shift.should =~ /Open/
    outputs.shift.should =~ /Hi james!/
    outputs.shift.should =~ /Hi Mike!/
    outputs.shift.should =~ /Hi bob!/
  end

end

describe Oughtve, "viewing notes with --verbose" do

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
    outputs.reject! {|line| line.nil? or line.empty? or line.strip =~ /^(-|=)+$/ }
    verses = Oughtve::Tangent.first(:name.eql => "tangy").current_chapter.verses.reverse

    outputs.shift.should =~ /tangy/
    outputs.shift.should =~ /Open/

    output = outputs.shift
    output.should =~ /Hi james!/
    output.should =~ /##{verses[0].id}/
    Time.parse(output.match(/\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}/)[0]).to_i.should == verses[0].time.to_i

    output = outputs.shift
    output.should =~ /Hi Mike!/
    output.should =~ /##{verses[1].id}/
    Time.parse(output.match(/\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}/)[0]).to_i.should == verses[1].time.to_i

    output = outputs.shift
    output.should =~ /Hi bob!/
    output.should =~ /##{verses[2].id}/
    Time.parse(output.match(/\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}/)[0]).to_i.should == verses[2].time.to_i
  end
end

describe Oughtve, "viewing notes" do

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
    outputs.reject! {|line| line.nil? or line.empty? or line.strip =~ /^(-|=)+$/ }

    outputs.shift.should =~ /tangy/
    outputs.shift.should =~ /Open/
    outputs.shift.should =~ /Hi Mike!/
    outputs.shift.should =~ /Hi bob!/
  end
end

describe Oughtve, "viewing both stricken and open notes with all" do
  before :each do
    Oughtve.run %w[ --new --tangent tangy --directory /tmp ]
    Oughtve.run %w[ --scribe --tangent tangy Hi bob! ]
    Oughtve.run %w[ --scribe --tangent tangy Hi Mike! ]
    Oughtve.run %w[ --scribe --tangent tangy Hi james! ]
    Oughtve.run %w[ --strike --tangent tangy --match Hi\ M ]
  end

  after :each do
    Oughtve::Tangent.all(:name.not => "default").each {|t| t.destroy }
  end

  it "shows stricken notes" do
    outputs = Oughtve.run(%w[ --show all --tangent tangy ]).split "\n"
    outputs.reject! {|line| line.nil? or line.empty? or line.strip =~ /^(-|=)+$/ }

    outputs.shift.should =~ /tangy/
    outputs.shift.should =~ /Open/

    outputs.shift.should =~ /Hi james!/
    outputs.shift.should =~ /Hi bob!/

    outputs.shift.should =~ /Closed/
    outputs.shift.should =~ /Hi Mike!/
  end
end

describe Oughtve, "viewing every note for a tangent form current and previous chapters with everything" do
  before :each do
    Oughtve.run %w[ --new --tangent tangy --directory /tmp ]
    Oughtve.run %w[ --scribe --tangent tangy Hi bob! ]
    Oughtve.run %w[ --scribe --tangent tangy Hi Mike! ]
    Oughtve.run %w[ --scribe --tangent tangy Hi james! ]
    Oughtve.run %w[ --strike --tangent tangy --match Hi\ M ]
    Oughtve.run %w[ --chapter End of part 1 --tangent tangy ]
    Oughtve.run %w[ --scribe --tangent tangy Hi Mo! ]
    Oughtve.run %w[ --scribe --tangent tangy Hi Bo! ]
    Oughtve.run %w[ --strike --tangent tangy --match Hi\ B ]
    Oughtve.run %w[ --chapter End of part 2 --tangent tangy ]
    Oughtve.run %w[ --scribe --tangent tangy Hi go! ]
    Oughtve.run %w[ --scribe --tangent tangy Hi lo! ]
    Oughtve.run %w[ --strike --tangent tangy --match Hi\ l ]
  end

  after :each do
    Oughtve::Tangent.all(:name.not => "default").each {|t| t.destroy }
  end

  it "shows all notes from this and previous chapters" do
    outputs = Oughtve.run(%w[ --show old --tangent tangy ]).split "\n"
    outputs.reject! {|line| line.nil? or line.empty? or line.strip =~ /^(-|=)+$/ }

    outputs.shift.should =~ /tangy/

    outputs.shift.should =~ /Open/
    outputs.shift.should =~ /Hi go!/

    outputs.shift.should =~ /Closed/
    outputs.shift.should =~ /Hi lo!/

    outputs.shift.should =~ /End of part 2/

    outputs.shift.should =~ /Open/
    outputs.shift.should =~ /Hi Mo!/

    outputs.shift.should =~ /Closed/
    outputs.shift.should =~ /Hi Bo!/

    outputs.shift.should =~ /End of part 1/

    outputs.shift.should =~ /Open/
    outputs.shift.should =~ /Hi james!/
    outputs.shift.should =~ /Hi bob!/

    outputs.shift.should =~ /Closed/
    outputs.shift.should =~ /Hi Mike!/
  end
end

describe Oughtve, "dumping a Tangent to YAML" do
  before :each do
    Oughtve.run %w[ --new --tangent tangy --directory /tmp ]
    Oughtve.run %w[ --scribe --tangent tangy Hi bob! ]
    Oughtve.run %w[ --scribe --tangent tangy Hi Mike! ]
    Oughtve.run %w[ --scribe --tangent tangy Hi james! ]
    Oughtve.run %w[ --strike --tangent tangy --match Hi\ M ]
    Oughtve.run %w[ --chapter End of part 1 --tangent tangy ]
    Oughtve.run %w[ --scribe --tangent tangy Hi Mo! ]
    Oughtve.run %w[ --scribe --tangent tangy Hi Bo! ]
    Oughtve.run %w[ --strike --tangent tangy --match Hi\ B ]
    Oughtve.run %w[ --chapter End of part 2 --tangent tangy ]
    Oughtve.run %w[ --scribe --tangent tangy Hi go! ]
    Oughtve.run %w[ --scribe --tangent tangy Hi lo! ]
    Oughtve.run %w[ --strike --tangent tangy --match Hi\ l ]
  end

  after :each do
    Oughtve::Tangent.all(:name.not => "default").each {|t| t.destroy }
  end

  it "contains all the data.. *sigh*" do
    fail
  end
end

describe Oughtve, "dumping a Tangent to JSON" do
  before :each do
    Oughtve.run %w[ --new --tangent tangy --directory /tmp ]
    Oughtve.run %w[ --scribe --tangent tangy Hi bob! ]
    Oughtve.run %w[ --scribe --tangent tangy Hi Mike! ]
    Oughtve.run %w[ --scribe --tangent tangy Hi james! ]
    Oughtve.run %w[ --strike --tangent tangy --match Hi\ M ]
    Oughtve.run %w[ --chapter End of part 1 --tangent tangy ]
    Oughtve.run %w[ --scribe --tangent tangy Hi Mo! ]
    Oughtve.run %w[ --scribe --tangent tangy Hi Bo! ]
    Oughtve.run %w[ --strike --tangent tangy --match Hi\ B ]
    Oughtve.run %w[ --chapter End of part 2 --tangent tangy ]
    Oughtve.run %w[ --scribe --tangent tangy Hi go! ]
    Oughtve.run %w[ --scribe --tangent tangy Hi lo! ]
    Oughtve.run %w[ --strike --tangent tangy --match Hi\ l ]
  end

  after :each do
    Oughtve::Tangent.all(:name.not => "default").each {|t| t.destroy }
  end

  it "contains all the data.. *sigh*" do
    fail
  end
end

