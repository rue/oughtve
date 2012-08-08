require_relative "./spec_helper"


describe Oughtve, "creating a new Tangent with --tangent when directory given" do

  before :each do
    Oughtve.bootstrap
  end

  it "creates a new Tangent for the specified directory path" do
    Oughtve::Tangent.all(:dir.not => "/").size.must_equal 0

    Oughtve.run %w[ --new --directory /usr ]

    tangents = Oughtve::Tangent.all :dir.not => "/"
    tangents.size.must_equal 1
    tangents.first.dir.must_equal "/usr"
  end

  it "does not create a Tangent for the current directory" do
    Oughtve::Tangent.all(:dir.not => "/").size.must_equal 0

    Oughtve.run %w[ --new --directory /usr ]

    Oughtve::Tangent.all(:dir => File.dirname(__FILE__)).size.must_equal 0
  end

  it "expands the directory name given" do
    Oughtve::Tangent.all(:dir.not => "/").size.must_equal 0

    Oughtve.run %w[ --new --tangent two --dir ./ ]

    tangents = Oughtve::Tangent.all :dir.not => "/"
    tangents.size.must_equal 1
    tangents.first.dir.must_equal Dir.pwd
    tangents.first.name.must_equal "two"
  end

  it "raises if the directory does not exist" do
    lambda { Oughtve.run %w[ --new --dir /uggabugga ] }.must_raise ArgumentError
  end

end

describe Oughtve, "creating a new Tangent with --tangent when name given" do

  before :each do
    Oughtve.bootstrap
  end

  it "stores the given name for the Tangent" do
    Oughtve::Tangent.all(:dir.not => "/").size.must_equal 0

    Oughtve.run %w[ --new --tangent tangy\ toobs --directory /tmp ]

    tangents = Oughtve::Tangent.all :dir.not => "/"
    tangents.size.must_equal 1
    tangents.first.dir.must_equal "/tmp"
    tangents.first.name.must_equal "tangy toobs"
  end

end

describe Oughtve, "creating a new Tangent with --tangent without a name" do

  before :each do
    Oughtve.bootstrap
  end

  it "uses the path as the Tangent's name also" do
    Oughtve::Tangent.all(:dir.not => "/").size.must_equal 0

    Oughtve.run %w[ --new --directory /tmp ]

    tangents = Oughtve::Tangent.all :dir.not => "/"
    tangents.size.must_equal 1
    tangents.first.dir.must_equal "/tmp"
    tangents.first.name.must_equal "/tmp"
  end
end

describe Oughtve, "creating a new Tangent" do

  before :each do
    Oughtve.bootstrap

    @dummyroot = "/tmp/oughtve_tangent_spec_#{$$}_#{Time.now.to_i}"
    @dummyhigher = File.join @dummyroot, "first"
    @dummylower = File.join @dummyhigher, "second"

    FileUtils.mkdir_p @dummylower
  end

  after :each do
    FileUtils.rm_r @dummyroot, :secure => true
  end

  it "uses current directory as the path if none is supplied" do
    Oughtve::Tangent.all(:dir.not => "/").size.must_equal 0

    Oughtve.run %w[ --new --tangent hi\ there ]

    tangents = Oughtve::Tangent.all :dir.not => "/"
    tangents.size.must_equal 1
    tangents.first.dir.must_equal Dir.pwd
    tangents.first.name.must_equal "hi there"
  end

  it "raises if a Tangent already exists for this exact path" do
    Oughtve.run %w[ --new --tangent hi ]

    tangents = Oughtve::Tangent.all :dir.not => "/"
    tangents.size.must_equal 1
    tangents.first.dir.must_equal Dir.pwd
    tangents.first.name.must_equal "hi"

    lambda { Oughtve.run %w[ --new --tangent hola ] }.must_raise ArgumentError
  end

  it "raises if a Tangent already exists with the same name" do
    Oughtve.run %w[ --new --tangent hi --directory /tmp ]

    tangents = Oughtve::Tangent.all :dir.not => "/"
    tangents.size.must_equal 1
    tangents.first.dir.must_equal "/tmp"
    tangents.first.name.must_equal "hi"

    lambda { Oughtve.run %w[ --new --tangent hi ] }.must_raise ArgumentError
  end

  it "can create a new Tangent below an existing one in the file hierarchy" do
    Oughtve.run %W[ --new --tangent hi --directory #{@dummyhigher} ]

    tangents = Oughtve::Tangent.all :dir.not => "/"
    tangents.size.must_equal 1
    tangents.first.dir.must_equal @dummyhigher
    tangents.first.name.must_equal "hi"

    Oughtve.run %W[ --new --tangent ho --directory #{@dummylower} ]

    tangents = Oughtve::Tangent.all :dir.not => "/"
    tangents.size.must_equal 2

    tangents.first.dir.must_equal @dummyhigher
    tangents.first.name.must_equal "hi"

    tangents.last.dir.must_equal @dummylower
    tangents.last.name.must_equal "ho"
  end

  it "can create a new Tangent above an existing one in the file hierarchy" do
    Oughtve.run %W[ --new --tangent hi --directory #{@dummylower} ]

    tangents = Oughtve::Tangent.all :dir.not => "/"
    tangents.size.must_equal 1
    tangents.first.dir.must_equal @dummylower
    tangents.first.name.must_equal "hi"

    Oughtve.run %W[ --new --tangent ho --directory #{@dummyhigher} ]

    tangents = Oughtve::Tangent.all :dir.not => "/"
    tangents.size.must_equal 2

    tangents.first.dir.must_equal @dummylower
    tangents.first.name.must_equal "hi"

    tangents.last.dir.must_equal @dummyhigher
    tangents.last.name.must_equal "ho"
  end

#  # TODO: Is this really necessary?
#  it "prints a warning if new Tangent being created above existing one" do
#    Oughtve.run %W[ --new --tangent hi --directory #{@dummylower} ]
#
#    tangents = Oughtve::Tangent.all :dir.not => "/"
#    tangents.size.must_equal 1
#
#    lambda {
#      Oughtve.run %W[ --new --tangent ho --directory #{@dummyhigher} ]
#    }.must_output "above", "above"
#
#    tangents = Oughtve::Tangent.all :dir.not => "/"
#    tangents.size.must_equal 2
#  end

  it "raises an error if the path does not exist in the filesystem" do
    nonesuch = "/foobar/#{$$}/#{Time.now.to_i}/#{rand 100}"
    File.exist?(nonesuch).must_equal false
    lambda { Oughtve.run %W[ --new --tangent hi --directory #{nonesuch} ] }.must_raise ArgumentError
  end

  it "creates the initial Chapter associated with the Tangent" do
    Oughtve.run %w[ --new --tangent something --directory /tmp ]

    tangent = Oughtve::Tangent.all(:dir.not => "/").first
    tangent.chapters.size.must_equal 1
  end
end
