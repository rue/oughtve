require_relative "./spec_helper"

describe Oughtve, "viewing notes given a tangent name" do

  before :each do
    Oughtve.bootstrap
    Oughtve.run %w[ --new --tangent tangy --directory /tmp ]
    Oughtve.run %w[ --scribe --tangent tangy Hi bob! ]
    Oughtve.run %w[ --scribe --tangent tangy Hi Mike! ]
    Oughtve.run %w[ --scribe --tangent tangy Hi james! ]
  end

  it "raises if named tangent cannot be found" do
    Oughtve::Tangent.all.size.must_equal 2

    lambda { Oughtve.run %w[  --show --tangent nonesuch ] }.must_raise ArgumentError
  end
end

describe Oughtve, "viewing notes without output options" do

  before :each do
    Oughtve.bootstrap
    Oughtve.run %w[ --new --tangent tangy --directory /tmp ]
    Oughtve.run %w[ --scribe --tangent tangy Hi bob! ]
    Oughtve.run %w[ --scribe --tangent tangy Hi Mike! ]
    Oughtve.run %w[ --scribe --tangent tangy Hi james! ]
  end

  it "produces a string containing text for all open notes for tangent" do
    outputs = Oughtve.run(%w[ --show --tangent tangy ]).split "\n"
    outputs.reject! {|line| line.nil? or line.empty? or line.strip =~ /^(-|=)+$/ }

    outputs.shift.must_match /tangy/
    outputs.shift.must_match /Open/
    outputs.shift.must_match /Hi james!/
    outputs.shift.must_match /Hi Mike!/
    outputs.shift.must_match /Hi bob!/
  end

end

describe Oughtve, "viewing notes with --verbose" do

  before :each do
    Oughtve.bootstrap
    Oughtve.run %w[ --new --tangent tangy --directory /tmp ]
    Oughtve.run %w[ --scribe --tangent tangy Hi bob! ]
    Oughtve.run %w[ --scribe --tangent tangy Hi Mike! ]
    Oughtve.run %w[ --scribe --tangent tangy Hi james! ]
  end

  it "includes time when note was scribed" do
    outputs = Oughtve.run(%w[ --show --tangent tangy --verbose ]).split "\n"
    outputs.reject! {|line| line.nil? or line.empty? or line.strip =~ /^(-|=)+$/ }
    verses = Oughtve::Tangent.first(:name => "tangy").current_chapter.verses.reverse

    outputs.shift.must_match /tangy/
    outputs.shift.must_match /Open/

    output = outputs.shift
    output.must_match /Hi james!/
    output.must_match /##{verses[0].id}/
    Time.parse(output.match(/\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}/)[0]).to_time.to_i.must_equal verses[0].time.to_time.to_i

    output = outputs.shift
    output.must_match /Hi Mike!/
    output.must_match /##{verses[1].id}/
    Time.parse(output.match(/\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}/)[0]).to_time.to_i.must_equal verses[1].time.to_time.to_i

    output = outputs.shift
    output.must_match /Hi bob!/
    output.must_match /##{verses[2].id}/
    Time.parse(output.match(/\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}/)[0]).to_time.to_i.must_equal verses[2].time.to_time.to_i
  end
end

describe Oughtve, "viewing notes" do

  before :each do
    Oughtve.bootstrap
    Oughtve.run %w[ --new --tangent tangy --directory /tmp ]
    Oughtve.run %w[ --scribe --tangent tangy Hi bob! ]
    Oughtve.run %w[ --scribe --tangent tangy Hi Mike! ]
    Oughtve.run %w[ --scribe --tangent tangy Hi james! ]
    Oughtve.run %w[ --strike --tangent tangy --match Hi\ j ]
  end

  it "does not show stricken notes" do
    outputs = Oughtve.run(%w[ --show --tangent tangy ]).split "\n"
    outputs.reject! {|line| line.nil? or line.empty? or line.strip =~ /^(-|=)+$/ }

    outputs.shift.must_match /tangy/
    outputs.shift.must_match /Open/
    outputs.shift.must_match /Hi Mike!/
    outputs.shift.must_match /Hi bob!/

    outputs.must_be_empty
  end
end

describe Oughtve, "viewing both stricken and open notes with all" do
  before :each do
    Oughtve.bootstrap
    Oughtve.run %w[ --new --tangent tangy --directory /tmp ]
    Oughtve.run %w[ --scribe --tangent tangy Hi bob! ]
    Oughtve.run %w[ --scribe --tangent tangy Hi Mike! ]
    Oughtve.run %w[ --scribe --tangent tangy Hi james! ]
    Oughtve.run %w[ --strike --tangent tangy --match Hi\ M ]
  end

  it "shows stricken notes" do
    outputs = Oughtve.run(%w[ --show all --tangent tangy ]).split "\n"
    outputs.reject! {|line| line.nil? or line.empty? or line.strip =~ /^(-|=)+$/ }

    outputs.shift.must_match /tangy/
    outputs.shift.must_match /Open/

    outputs.shift.must_match /Hi james!/
    outputs.shift.must_match /Hi bob!/

    outputs.shift.must_match /Closed/
    outputs.shift.must_match /Hi Mike!/
  end
end

describe Oughtve, "viewing every note for a tangent form current and previous chapters with everything" do
  before :each do
    Oughtve.bootstrap
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

    outputs.shift.must_match /tangy/

    outputs.shift.must_match /Open/
    outputs.shift.must_match /Hi go!/

    outputs.shift.must_match /Closed/
    outputs.shift.must_match /Hi lo!/

    outputs.shift.must_match /End of part 2/

    outputs.shift.must_match /Open/
    outputs.shift.must_match /Hi Mo!/

    outputs.shift.must_match /Closed/
    outputs.shift.must_match /Hi Bo!/

    outputs.shift.must_match /End of part 1/

    outputs.shift.must_match /Open/
    outputs.shift.must_match /Hi james!/
    outputs.shift.must_match /Hi bob!/

    outputs.shift.must_match /Closed/
    outputs.shift.must_match /Hi Mike!/
  end
end

# TODO: Verify YAML/JSON
