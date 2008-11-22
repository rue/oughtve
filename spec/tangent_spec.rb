require File.join File.dirname(__FILE__), "spec_helper"


describe Oughtve, "creating a new Tangent when directory given" do

  after :each do
    Oughtve::Tangent.all(:dir.not => "/").each {|t| t.destroy }
  end

  it "creates a new Tangent for the specified directory path" do
    Oughtve::Tangent.all(:dir.not => "/").size.should == 0

    Oughtve.run %w[ new --directory /something ]

    tangents = Oughtve::Tangent.all :dir.not => "/"
    tangents.size.should == 1
    tangents.first.dir.should == "/something"
  end

  it "does not create a Tangent for the current directory" do
    Oughtve::Tangent.all(:dir.not => "/").size.should == 0

    Oughtve.run %w[ new --directory /something ]

    Oughtve::Tangent.all(:dir.eql => File.dirname(__FILE__)).size.should == 0
  end

end

describe Oughtve, "creating a new Tangent when name given" do

  after :each do
    Oughtve::Tangent.all(:dir.not => "/").each {|t| t.destroy }
  end

  it "stores the given name for the Tangent" do
    Oughtve::Tangent.all(:dir.not => "/").size.should == 0

    Oughtve.run %w[ new --tangent tangy\ toobs --directory /bla ]

    tangents = Oughtve::Tangent.all :dir.not => "/"
    tangents.size.should == 1
    tangents.first.dir.should == "/bla"
    tangents.first.name.should == "tangy toobs"
  end

end

describe Oughtve, "creating a new Tangent without a name" do

  after :each do
    Oughtve::Tangent.all(:dir.not => "/").each {|t| t.destroy }
  end

  it "uses the path as the Tangent's name also" do
    Oughtve::Tangent.all(:dir.not => "/").size.should == 0

    Oughtve.run %w[ new --directory /bla ]

    tangents = Oughtve::Tangent.all :dir.not => "/"
    tangents.size.should == 1
    tangents.first.dir.should == "/bla"
    tangents.first.name.should == "/bla"
  end

end

describe Oughtve, "creating a new Tangent with --tangent" do

  it "uses current directory as the path if none is supplied" do
    fail
  end

  it "raises if a Tangent already exists for this exact path" do
    fail
  end

  it "raises if a Tangent already exists with the same name" do
    fail
  end

  it "can create a new Tangent below an existing one in the file hierarchy" do
    fail
  end

  it "can create a new Tangent above an existing one in the file hierarchy" do
    fail
  end

  it "prints a warning if new Tangent being created above existing one" do
    fail
  end

  it "raises an error if the path does not exist in the filesystem" do
    fail
  end

  it "raises an error if the --path or --name flag is supplied without an argument" do
    fail
  end

  it "creates the initial Chapter associated with the Tangent" do
    Oughtve.run %w[ new --tangent something --directory /bla ]

    tangent = Oughtve::Tangent.all(:dir.not => "/").first
    tangent.chapters.size.should == 1
  end
end
