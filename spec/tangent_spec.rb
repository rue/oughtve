require File.join File.dirname(__FILE__), "spec_helper"


describe Oughtve, "creating a new Tangent with --tangent when directory given" do

  after :each do
    Oughtve::Tangent.all(:dir.not => "/").each {|t| t.destroy }
  end

  it "creates a new Tangent for the specified directory path" do
    Oughtve::Tangent.all(:dir.not => "/").size.should == 0

    Oughtve.run %w[ --new --directory /usr ]

    tangents = Oughtve::Tangent.all :dir.not => "/"
    tangents.size.should == 1
    tangents.first.dir.should == "/usr"
  end

  it "does not create a Tangent for the current directory" do
    Oughtve::Tangent.all(:dir.not => "/").size.should == 0

    Oughtve.run %w[ --new --directory /usr ]

    Oughtve::Tangent.all(:dir.eql => File.dirname(__FILE__)).size.should == 0
  end

  it "expands the directory name given" do
    Oughtve::Tangent.all(:dir.not => "/").size.should == 0

    Oughtve.run %w[ --new --tangent two --dir ./ ]

    tangents = Oughtve::Tangent.all :dir.not => "/"
    tangents.size.should == 1
    tangents.first.dir.should == Dir.pwd
    tangents.first.name.should == "two"
  end

  it "raises if the directory does not exist" do
    lambda { Oughtve.run %w[ --new --dir /uggabugga ] }.should raise_error(ArgumentError)
  end

end

describe Oughtve, "creating a new Tangent with --tangent when name given" do

  after :each do
    Oughtve::Tangent.all(:dir.not => "/").each {|t| t.destroy }
  end

  it "stores the given name for the Tangent" do
    Oughtve::Tangent.all(:dir.not => "/").size.should == 0

    Oughtve.run %w[ --new --tangent tangy\ toobs --directory /tmp ]

    tangents = Oughtve::Tangent.all :dir.not => "/"
    tangents.size.should == 1
    tangents.first.dir.should == "/tmp"
    tangents.first.name.should == "tangy toobs"
  end

end

describe Oughtve, "creating a new Tangent with --tangent without a name" do

  after :each do
    Oughtve::Tangent.all(:dir.not => "/").each {|t| t.destroy }
  end

  it "uses the path as the Tangent's name also" do
    Oughtve::Tangent.all(:dir.not => "/").size.should == 0

    Oughtve.run %w[ --new --directory /tmp ]

    tangents = Oughtve::Tangent.all :dir.not => "/"
    tangents.size.should == 1
    tangents.first.dir.should == "/tmp"
    tangents.first.name.should == "/tmp"
  end

end

describe Oughtve, "creating a new Tangent" do

  after :each do
    Oughtve::Tangent.all(:dir.not => "/").each {|t| t.destroy }
  end

  it "uses current directory as the path if none is supplied" do
    Oughtve::Tangent.all(:dir.not => "/").size.should == 0

    Oughtve.run %w[ --new --tangent hi\ there ]

    tangents = Oughtve::Tangent.all :dir.not => "/"
    tangents.size.should == 1
    tangents.first.dir.should == Dir.pwd
    tangents.first.name.should == "hi there"
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
    Oughtve.run %w[ --new --tangent something --directory /tmp ]

    tangent = Oughtve::Tangent.all(:dir.not => "/").first
    tangent.chapters.size.should == 1
  end
end
