require File.join File.dirname(__FILE__), "spec_helper"

require "fileutils"
require "ostruct"


describe Oughtve, "deleting tangents" do
  before :each do
    Oughtve.run %w[ --new --tangent doomed ]
  end

  after :each do
    Oughtve::Tangent.all(:name.not => "default").each {|t| t.destroy }
  end

  it "requires tangent name" do
    lambda { Oughtve.run %w[ --delete ] }.should raise_error
    lambda { Oughtve.run %W[ --delete --directory #{Dir.pwd} ] }.should raise_error
  end

  it "does not allow deleting the default tangent" do
    lambda { Oughtve.run %w[ --delete --tangent default ] }.should raise_error
  end

  it "raises if tangent name not found" do
    lambda { Oughtve.run %w[ --delete --tangent Doomed ] }.should raise_error
    lambda { Oughtve.run %w[ --delete --tangent uggabugga ] }.should raise_error
  end

  it "deletes the Tangent object" do
    Oughtve::Tangent.all(:dir.not => "/").size.should == 1
    Oughtve.run %w[ --delete --tangent doomed ]
    Oughtve::Tangent.all(:dir.not => "/").size.should == 0
  end

end

describe Oughtve, "deleting tangents with direct parameter to --delete" do
  before :each do
    Oughtve.run %w[ --new --tangent doomed ]
  end

  after :each do
    Oughtve::Tangent.all(:name.not => "default").each {|t| t.destroy }
  end

  it "deletes the tangent named as the parameter" do
    Oughtve::Tangent.all(:dir.not => "/").size.should == 1
    Oughtve.run %w[ --delete doomed ]
    Oughtve::Tangent.all(:dir.not => "/").size.should == 0
  end
end
