require File.join File.dirname(__FILE__), "spec_helper"

describe Oughtve, "starting a new chapter" do

  before :each do
    Oughtve.run %w[ --new --tangent tangy --directory /tmp ]
    Oughtve.run %w[ --scribe --tangent tangy Hi bob! ]
    Oughtve.run %w[ --scribe --tangent tangy Hi Mike! ]
    Oughtve.run %w[ --scribe --tangent tangy Hi james! ]
  end

  after :each do
    Oughtve::Tangent.all(:name.not => "default").each {|t| t.destroy }
  end

  it "moves previous chapter to chapters and replaces it as current_chapter" do
    tangent = Oughtve::Tangent.first :name.eql => "tangy"

    previous = tangent.current_chapter

    previous.should_not == nil
    tangent.chapters.should == [previous]

    Oughtve.run %w[ --chapter End of part 1 --tangent tangy ]

    tangent.reload
    current = tangent.current_chapter

    current.should_not == nil
    current.should_not == previous

    tangent.chapters.include?(previous).should == true
    tangent.chapters.include?(current).should == true
  end

end
