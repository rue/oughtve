require_relative "./spec_helper"

require "stringio"


describe Oughtve, "scribing a new note with Tangent specified" do

  before :each do
    Oughtve.bootstrap
    Oughtve.run %w[ --new --tangent scriby --directory /var ]
    Oughtve.run %w[ --new --tangent other --directory /tmp ]
  end

  it "creates a new Verse under the Tangent specified" do
    Oughtve.run %w[ --scribe --tangent scriby --text Hi\ there ]

    verses = Oughtve::Tangent.first(:name => "scriby").current_chapter.verses
    verses.size.must_equal 1
    verses.first.text.must_equal "Hi there"
  end

  it "raises an error if the name cannot be found" do
    lambda { Oughtve.run %w[ --scribe --tangent nonesuch --text Uh-oh! ] }.must_raise ArgumentError
  end

end

describe Oughtve, "scribing a new note with directory specified" do

  before :each do
    Oughtve.bootstrap
    Oughtve.run %w[ --new --tangent scriby --directory /var ]
    Oughtve.run %w[ --new --tangent other --directory /tmp ]
  end

  it "creates a new Verse under the Tangent for the directory" do
    Oughtve.run %w[ --scribe --directory /var --text Ho\ there ]

    verses = Oughtve::Tangent.first(:name => "scriby").current_chapter.verses
    verses.size.must_equal 1
    verses.first.text.must_equal "Ho there"
  end

end

describe Oughtve, "scribing a new note without specifying a Tangent or directory" do

  before :each do
    Oughtve.bootstrap
    Oughtve.run %w[ --new --tangent scriby ]
    Oughtve.run %w[ --new --tangent other --directory /tmp ]
  end

  it "creates a new Verse under the Tangent for current directory" do
    Oughtve.run %w[ --scribe --text Hu\ there ]

    verses = Oughtve::Tangent.first(:name => "scriby").current_chapter.verses
    verses.size.must_equal 1
    verses.first.text.must_equal "Hu there"
  end
end

describe Oughtve, "scribing a new note" do

  before :each do
    Oughtve.bootstrap
    Oughtve.run %w[ --new --tangent scriby ]
    Oughtve.run %w[ --new --tangent other --directory /tmp ]
  end

  it "stores the time the note was created" do
    # Trying to save/load subsecond is tricky, so we only care about seconds.
    before = Time.now.to_i
    Oughtve.run %w[ --scribe --text He\ there ]
    after = Time.now.to_i

    verses = Oughtve::Tangent.first(:name => "scriby").current_chapter.verses
    verses.size.must_equal 1
    verses.first.text.must_equal "He there"

    (before..after).must_include verses.first.time.to_time.to_i
  end

  it "produces a note that is not stricken" do
    Oughtve.run %w[ --scribe --text Moo\ there ]

    tangent = Oughtve::Tangent.first :name => "scriby"
    tangent.current_chapter.verses.first.struck.must_be_nil
  end

  it "assumes any straggling nonoption parameters are a part of the text" do
    Oughtve.run %w[ --scribe --text Aha there ]

    verses = Oughtve::Tangent.first(:name => "scriby").current_chapter.verses
    verses.size.must_equal 1
    verses.first.text.must_equal "Aha there"
  end

  it "will read standard input if no text is given" do
    $stdin = StringIO.new "Moo, this is standard\ninput!\n\nReally!\n"

    Oughtve.run %w[ --scribe Moo, this is standard\ninput!\n\nReally!\n ]

    verses = Oughtve::Tangent.first(:name => "scriby").current_chapter.verses
    verses.size.must_equal 1
    verses.first.text.must_equal "Moo, this is standard\ninput!\n\nReally!"
  end
#
#  it "raises an error if no message is given even in standard input" do
#    $stdin = StringIO.new "\n"
#
#    lambda { Oughtve.run %w[ --scribe --tangent scriby ] }.must_raise
#  end
end
