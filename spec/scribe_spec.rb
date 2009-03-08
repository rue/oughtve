require File.join File.dirname(__FILE__), "spec_helper"

require "stringio"


describe Oughtve, "scribing a new note with Tangent specified" do

  before :each do
    Oughtve.run %w[ --new --tangent scriby --directory /var ]
    Oughtve.run %w[ --new --tangent other --directory /tmp ]
  end

  after :each do
    Oughtve::Verse.all.each {|t| t.destroy }
    Oughtve::Chapter.all.each {|t| t.destroy }
    Oughtve::Tangent.all(:dir.not => "/").each {|t| t.destroy }
  end

  it "creates a new Verse under the Tangent specified" do
    Oughtve.run %w[ --scribe --tangent scriby --text Hi\ there ]

    verses = Oughtve::Tangent.first(:name => "scriby").current_chapter.verses
    verses.size.should == 1
    verses.first.text.should == "Hi there"
  end

  it "raises an error if the name cannot be found" do
    lambda { Oughtve.run %w[ --scribe --tangent nonesuch --text Uh-oh! ] }.should raise_error
  end

end

describe Oughtve, "scribing a new note with directory specified" do

  before :each do
    Oughtve.run %w[ --new --tangent scriby --directory /var ]
    Oughtve.run %w[ --new --tangent other --directory /tmp ]
  end

  after :each do
    Oughtve::Verse.all.each {|t| t.destroy }
    Oughtve::Chapter.all.each {|t| t.destroy }
    Oughtve::Tangent.all(:dir.not => "/").each {|t| t.destroy }
  end

  it "creates a new Verse under the Tangent for the directory" do
    Oughtve.run %w[ --scribe --directory /var --text Ho\ there ]

    verses = Oughtve::Tangent.first(:name => "scriby").current_chapter.verses
    verses.size.should == 1
    verses.first.text.should == "Ho there"
  end

end

describe Oughtve, "scribing a new note without specifying a Tangent or directory" do

  before :each do
    Oughtve.run %w[ --new --tangent scriby ]
    Oughtve.run %w[ --new --tangent other --directory /tmp ]
  end

  after :each do
    Oughtve::Verse.all.each {|t| t.destroy }
    Oughtve::Chapter.all.each {|t| t.destroy }
    Oughtve::Tangent.all(:dir.not => "/").each {|t| t.destroy }
  end

  it "creates a new Verse under the Tangent for current directory" do
    Oughtve.run %w[ --scribe --text Hu\ there ]

    verses = Oughtve::Tangent.first(:name => "scriby").current_chapter.verses
    verses.size.should == 1
    verses.first.text.should == "Hu there"
  end

end

describe Oughtve, "scribing a new note" do

  before :each do
    Oughtve.run %w[ --new --tangent scriby ]
    Oughtve.run %w[ --new --tangent other --directory /tmp ]
  end

  after :each do
    Oughtve::Verse.all.each {|t| t.destroy }
    Oughtve::Chapter.all.each {|t| t.destroy }
    Oughtve::Tangent.all(:dir.not => "/").each {|t| t.destroy }

    $stdin = STDIN
  end

  it "stores the time the note was created" do
    before = Time.now
    Oughtve.run %w[ --scribe --text He\ there ]
    after = Time.now

    verses = Oughtve::Tangent.first(:name => "scriby").current_chapter.verses
    verses.size.should == 1
    verses.first.text.should == "He there"
    (before...after).should include(verses.first.time)
  end

  it "is not stricken" do
    Oughtve.run %w[ --scribe --text Moo\ there ]

    tangent = Oughtve::Tangent.first :name => "scriby"
    (!!tangent.current_chapter.verses.first.stricken).should_not == true
  end

  it "assumes any straggling nonoption parameters are a part of the text" do
    Oughtve.run %w[ --scribe --text Aha there ]

    verses = Oughtve::Tangent.first(:name => "scriby").current_chapter.verses
    verses.size.should == 1
    verses.first.text.should == "Aha there"
  end

  it "will read standard input if no text is given" do
    $stdin = StringIO.new "Moo, this is standard\ninput!\n\nReally!\n"

    Oughtve.run %w[ --scribe ]

    verses = Oughtve::Tangent.first(:name => "scriby").current_chapter.verses
    verses.size.should == 1
    verses.first.text.should == "Moo, this is standard\ninput!\n\nReally!"
  end

  it "raises an error if no message is given even in standard input" do
    $stdin = StringIO.new ""

    lambda { Oughtve.run %w[ --scribe --tangent scriby ] }.should raise_error
  end

end
