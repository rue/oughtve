require File.join File.dirname(__FILE__), "spec_helper"

require "fileutils"
require "ostruct"


describe Oughtve, "locating tangents" do
  before :all do
    @specdir = File.expand_path "#{Dir.pwd}/spec"
    @one_up = File.expand_path "#{Dir.pwd}/.."
    @two_up = File.expand_path "#{Dir.pwd}/../.."
    @three_up = File.expand_path "#{Dir.pwd}/../../.."
    @four_up = File.expand_path "#{Dir.pwd}/../../../.."

    Oughtve.run "--new --tangent one_down   --directory #{@one_up}".split /\s/
    Oughtve.run "--new --tangent three_down --directory #{@three_up}".split /\s/
  end

  it "uses current directory's tangent if there is one" do
    Dir.chdir @one_up do
      Oughtve.tangent_for(OpenStruct.new :dir => Dir.pwd).name.should == "one_down"
    end

    Dir.chdir @three_up do
      Oughtve.tangent_for(OpenStruct.new :dir => Dir.pwd).name.should == "three_down"
    end
  end

  it "climbs straight up directory hierarchy until finding directory with a tangent" do
    Dir.chdir @specdir do
      Oughtve.tangent_for(OpenStruct.new :dir => Dir.pwd).name.should == "one_down"
    end

    Dir.chdir @two_up do
      Oughtve.tangent_for(OpenStruct.new :dir => Dir.pwd).name.should == "three_down"
    end
  end

  it "falls back on default at / if no others match along the way" do
    Dir.chdir @four_up do
      Oughtve.tangent_for(OpenStruct.new :dir => Dir.pwd).name.should == "default"
    end
  end
end
