require_relative "./spec_helper"

describe Oughtve, "starting a new chapter" do

  before :each do
    Oughtve.bootstrap
    Oughtve.run %w[ --new --tangent tangy --directory /tmp ]
    Oughtve.run %w[ --scribe --tangent tangy Hi bob! ]
    Oughtve.run %w[ --scribe --tangent tangy Hi Mike! ]
    Oughtve.run %w[ --scribe --tangent tangy Hi james! ]
  end

  it "moves previous chapter to chapters and replaces it as current_chapter" do
    tangent = Oughtve::Tangent.first :name => "tangy"

    previous = tangent.current_chapter

    previous.wont_be_nil
    tangent.chapters.must_equal [previous]

    Oughtve.run %w[ --chapter End of part 1 --tangent tangy ]

    tangent.reload
    current = tangent.current_chapter

    current.wont_be_nil
    current.wont_equal previous

    tangent.chapters.must_include previous
    tangent.chapters.must_include current
  end

end
