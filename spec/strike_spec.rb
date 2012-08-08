require_relative "./spec_helper"

describe Oughtve, "marking notes done or closed with --strike using the note's ID" do

  before :each do
    Oughtve.bootstrap
    Oughtve.run %w[ --new --tangent tangy --directory /tmp ]
    Oughtve.run %w[ --scribe --tangent tangy Hi bob! ]
    Oughtve.run %w[ --scribe --tangent tangy Hi Mike! ]
    Oughtve.run %w[ --scribe --tangent tangy Hi james! ]
  end

  it "it sets the 'stricken' field to the time stricken" do
    verse = Oughtve::Tangent.first(:name => "tangy").current_chapter.verses.last

    verse.struck.must_be_nil

    before = Time.now.to_i
    Oughtve.run "--strike --id #{verse.id}".split(" ")
    after = Time.now.to_i

    verse = Oughtve::Tangent.first(:name => "tangy").current_chapter.verses.last

    (before..after).must_include verse.struck.to_time.to_i
  end

  it "raises if the ID does not exist" do
    lambda { Oughtve.run %w[ --strike --id 100 ] }.must_raise ArgumentError
  end

end


describe Oughtve, "marking notes done or closed with --strike using text matching" do

  before :each do
    Oughtve.bootstrap
    Oughtve.run %w[ --new --tangent tangy --directory /tmp ]
    Oughtve.run %w[ --scribe --tangent tangy Hi bob! ]
    Oughtve.run %w[ --scribe --tangent tangy Hi Mike! ]
    Oughtve.run %w[ --scribe --tangent tangy Hi james! ]
  end

  it "sets the stricken field if given text is an unambiguous regexp match to an open note in current tangent" do
    verse = Oughtve::Tangent.first(:name => "tangy").current_chapter.verses.last

    verse.struck.must_be_nil

    before = Time.now.to_i
    Oughtve.run %w[--strike --tangent tangy --match Hi\ j ]
    after = Time.now.to_i

    verse = Oughtve::Tangent.first(:name => "tangy").current_chapter.verses.last

    (before..after).must_include verse.struck.to_time.to_i
  end

  it "raises if Note cannot be matched" do
    lambda { Oughtve.run %w[--strike --tangent tangy --match hi\ james ] }.must_raise ArgumentError
  end

  it "raises if Note cannot be matched unambiguously" do
    lambda { Oughtve.run %w[--strike --tangent tangy --match Hi ] }.must_raise ArgumentError
  end

end

describe Oughtve, "striking notes with parameter directly to --strike" do

  before :each do
    Oughtve.bootstrap
    Oughtve.run %w[ --new --tangent tangy --directory /tmp ]
    Oughtve.run %w[ --scribe --tangent tangy Hi bob! ]
    Oughtve.run %w[ --scribe --tangent tangy Hi Mike! ]
    Oughtve.run %w[ --scribe --tangent tangy Hi james! ]
  end

  it "uses parameter as Integer when possible" do
    verse = Oughtve::Tangent.first(:name => "tangy").current_chapter.verses.last

    verse.struck.must_be_nil

    before = Time.now.to_i
    Oughtve.run %W[--strike #{verse.id} --tangent tangy ]
    after = Time.now.to_i

    verse = Oughtve::Tangent.first(:name => "tangy").current_chapter.verses.last

    (before..after).must_include verse.struck.to_time.to_i
  end

  it "uses parameter as regular expression if it is not an Integer" do
    verse = Oughtve::Tangent.first(:name => "tangy").current_chapter.verses.last

    verse.struck.must_be_nil

    before = Time.now.to_i
    Oughtve.run %w[ --strike Hi\ j --tangent tangy ]
    after = Time.now.to_i

    verse = Oughtve::Tangent.first(:name => "tangy").current_chapter.verses.last

    (before..after).must_include verse.struck.to_time.to_i
  end

end

describe Oughtve, "marking notes done or closed with --strike" do

  before :each do
    Oughtve.bootstrap
    Oughtve.run %w[ --new --tangent tangy --directory /tmp ]
    Oughtve.run %w[ --scribe --tangent tangy Hi bob! ]
    Oughtve.run %w[ --scribe --tangent tangy Hi Mike! ]
    Oughtve.run %w[ --scribe --tangent tangy Hi james! ]
  end

  it "raises if note already stricken" do
    verse = Oughtve::Tangent.first(:name => "tangy").current_chapter.verses.last

    verse.struck.must_be_nil

    before = Time.now.to_i
    Oughtve.run %w[--strike --tangent tangy --match Hi\ j ]
    after = Time.now.to_i

    verse = Oughtve::Tangent.first(:name => "tangy").current_chapter.verses.last

    (before..after).must_include verse.struck.to_time.to_i

    lambda { Oughtve.run %w[ --strike --tangent tangy --match Hi\ j ] }.must_raise ArgumentError
  end

end

