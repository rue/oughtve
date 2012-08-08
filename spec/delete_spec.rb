require_relative "./spec_helper"

describe Oughtve, "deleting tangents" do
  before :each do
    Oughtve.bootstrap
    Oughtve.run %w[ --new --tangent doomed ]
  end

  it "raises if no tangent name given" do
    lambda { Oughtve.run %w[ --delete ] }.must_raise ArgumentError
    lambda { Oughtve.run %W[ --delete --directory #{Dir.pwd} ] }.must_raise ArgumentError
  end

  it "does not allow deleting the default tangent" do
    lambda { Oughtve.run %w[ --delete --tangent default ] }.must_raise ArgumentError
  end

  it "raises if tangent name is supplied but not found" do
    lambda { Oughtve.run %w[ --delete --tangent Doomed ] }.must_raise ArgumentError
    lambda { Oughtve.run %w[ --delete --tangent uggabugga ] }.must_raise ArgumentError
  end

  it "deletes the Tangent object" do
    Oughtve::Tangent.all(:dir.not => "/").size.must_equal 1
    Oughtve.run %w[ --delete --tangent doomed ]
    Oughtve::Tangent.all(:dir.not => "/").size.must_equal 0
  end

end

describe Oughtve, "deleting tangents with direct parameter to --delete" do
  before :each do
    Oughtve.bootstrap
    Oughtve.run %w[ --new --tangent doomed ]
  end

  it "deletes the tangent named as the parameter" do
    Oughtve::Tangent.all(:dir.not => "/").size.must_equal 1
    Oughtve.run %w[ --delete doomed ]
    Oughtve::Tangent.all(:dir.not => "/").size.must_equal 0
  end

  it "gives some kind of a confirmation" do
    output = Oughtve.run %w[ --delete doomed ]

    output.must_match /doomed/
    output.must_match /deleted/i
  end
end
