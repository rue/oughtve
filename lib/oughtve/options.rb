require "optparse"
require "ostruct"

module Oughtve

  #
  # Parse allowed options from given arguments
  #
  def self.parse_from(arguments)
    result = OpenStruct.new

    # Grab time here to be a bit closer to true
    result.time = Time.now

    def result.action!(given)
      raise ArgumentError, "Two actions given: 1) --#{action}, 2) --#{given}" if action
      self.action = given
    end

    OptionParser.new do |opts|

      opts.banner = "Usage: #{$0} [--ACTION [OPTIONS]]"

      opts.separator ""
      opts.separator "  Use `#{$0} --help ACTION` for more help."

      opts.separator ""
      opts.separator "  Actions:"


      # Actions

      opts.on "-n", "--new", "Create new Tangent." do
        result.action! :tangent
      end

      opts.on "-s", "--setup", "Set up database and initial structures." do
        result.action! :setup
      end

      # Options

      opts.on "-d", "--directory DIR", "Use given directory instead of Dir.pwd" do |dir|
        result.dir = dir
      end

      opts.on "-t", "--tangent NAME", "Use named Tangent specifically" do |name|
        result.name = name
      end

    end.parse! arguments

    result
  end

end
