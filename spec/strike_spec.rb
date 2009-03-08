require File.join File.dirname(__FILE__), "spec_helper"

describe Oughtve, "marking notes done or closed with --strike using the note's ID" do

  before :each do
    Oughtve.run %w[ --new --tangent tangy --directory /tmp ]
    Oughtve.run %w[ --scribe --tangent tangy Hi bob! ]
    Oughtve.run %w[ --scribe --tangent tangy Hi Mike! ]
    Oughtve.run %w[ --scribe --tangent tangy Hi james! ]
  end

  after :each do
    Oughtve::Tangent.all(:name.not => "default").each {|t| t.destroy }
  end

  it "it sets the 'stricken' field to the time stricken" do
    verse = Oughtve::Tangent.first(:name.eql => "tangy").current_chapter.verses.last

    (!!verse.stricken).should == false

    before = Time.now
    Oughtve.run "--strike --id #{verse.id}".split(" ")
    after = Time.now

    verse = Oughtve::Tangent.first(:name.eql => "tangy").current_chapter.verses.last

    (before..after).should include(verse.stricken)
  end

  it "raises if the ID does not exist" do
    lambda { Oughtve.run %w[ --strike --id 100 ] }.should raise_error
  end

end

describe Oughtve, "marking notes done or closed with --strike using text matching" do

  before :each do
    Oughtve.run %w[ --new --tangent tangy --directory /tmp ]
    Oughtve.run %w[ --scribe --tangent tangy Hi bob! ]
    Oughtve.run %w[ --scribe --tangent tangy Hi Mike! ]
    Oughtve.run %w[ --scribe --tangent tangy Hi james! ]
  end

  after :each do
    Oughtve::Tangent.all(:name.not => "default").each {|t| t.destroy }
  end

  it "sets the stricken field if given text is an unambiguous regexp match to an open note in current tangent" do
    verse = Oughtve::Tangent.first(:name.eql => "tangy").current_chapter.verses.last

    (!!verse.stricken).should == false

    before = Time.now
    Oughtve.run %w[--strike --tangent tangy --match Hi\ j ]
    after = Time.now

    verse = Oughtve::Tangent.first(:name.eql => "tangy").current_chapter.verses.last

    (before..after).should include(verse.stricken)
  end

  it "raises if Note cannot be matched" do
    lambda {
      Oughtve.run %w[--strike --tangent tangy --match hi\ james ]
    }.should raise_error
  end

  it "raises if Note cannot be matched unambiguously" do
    lambda {
      Oughtve.run %w[--strike --tangent tangy --match Hi ]
    }.should raise_error
  end

end

describe Oughtve, "marking notes done or closed with --strike" do

  before :each do
    Oughtve.run %w[ --new --tangent tangy --directory /tmp ]
    Oughtve.run %w[ --scribe --tangent tangy Hi bob! ]
    Oughtve.run %w[ --scribe --tangent tangy Hi Mike! ]
    Oughtve.run %w[ --scribe --tangent tangy Hi james! ]
  end

  after :each do
    Oughtve::Tangent.all(:name.not => "default").each {|t| t.destroy }
  end

  it "raises if note already stricken" do
    verse = Oughtve::Tangent.first(:name.eql => "tangy").current_chapter.verses.last

    (!!verse.stricken).should == false

    before = Time.now
    Oughtve.run %w[--strike --tangent tangy --match Hi\ j ]
    after = Time.now

    verse = Oughtve::Tangent.first(:name.eql => "tangy").current_chapter.verses.last

    (before..after).should include(verse.stricken)

    lambda { Oughtve.run %w[ --strike --tangent tangy --match Hi\ j ] }.should raise_error
  end

end
