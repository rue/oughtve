require "optparse"
require "ostruct"

module Oughtve

  #
  # Parse allowed options from given arguments
  #
  def self.parse_from(arguments)
    result = OpenStruct.new

    OptionParser.new do |opts|

      opts.banner = "Usage: #{$0} [--ACTION [OPTIONS]]"

      opts.separator ""
      opts.separator "  Use `#{$0} --help ACTION` for more help."

      opts.separator ""
      opts.separator "  Available actions:"
      opts.separator ""
      opts.separator "    new     Create a new Tangent."
      opts.separator "    scribe  Enter a new note."
      opts.separator "    setup   Bootstrap database &c. for first use."

      # Options
      opts.separator ""
      opts.separator "  Available options:"

      opts.on "-d", "--directory DIR", "Use given directory instead of Dir.pwd" do |dir|
        result.dir = dir
      end

      opts.on "-t", "--tangent NAME", "Use named Tangent specifically" do |name|
        result.name = name
      end

    end.parse! arguments

    result.action = case arguments.first
                    when "new"
                      :tangent
                    when "scribe"
                      :scribe
                    when "setup"
                      :setup
                    else
                      raise ArgumentError, "No action named #{ARGV.first}!"
                    end
    result
  end

end
