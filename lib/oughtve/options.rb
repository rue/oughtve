
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
      opts.separator "  Actions:"


      # Actions

      opts.on "-s", "--scribe [TEXT]", "Enter a new note." do |text|
        result.action! :scribe
        result.text = text
      end

      opts.on "-S", "--strike [ID_OR_REGEXP]", "Strike out a note." do |id_or_regexp|
        result.action! :strike

        if id_or_regexp
          begin
            result.serial = Integer(id_or_regexp)
          rescue ArgumentError
            result.regexp = /#{Regexp.escape id_or_regexp}/
          end
        end
      end

      opts.on "-w", "--show [all | old]", "Show notes for tangent(s). [All notes / old chapters too]" do |specifier|
        result.action! :show

        if specifier
          case specifier
          when "all"
            result.all = true
          when "old"
            result.all = true
            result.old = true
          else
            raise ArgumentError, "--show #{specifier} is not a valid option!" 
          end
        end
      end

      opts.on "-l", "--list", "Show defined Tangents and their base directories." do
        result.action! :list
      end

      opts.on "-c", "--chapter ENDNOTE", "Mark end of chapter and start new one." do |endnote|
        result.action! :chapter
        result.endnote = endnote
      end


      # Options
      opts.separator ""
      opts.separator "  Maintenance Actions:"

      opts.on "-b", "--bootstrap", "Set up database and initial structures." do
        result.action! :bootstrap
      end

      opts.on "-n", "--new", "Create new Tangent. (Use -t to give it a name.)" do
        result.action! :tangent
      end

      opts.on "-D", "--delete [NAME]", "Delete tangent." do |name|
        result.action! :delete
        result.name = name
      end


      # Options
      opts.separator ""
      opts.separator "  Options:"

      opts.on "-d", "--directory DIR", "Use given directory instead of Dir.pwd." do |dir|
        result.dir = dir
      end

      opts.on "-i", "--id ID", "Use specific note ID." do |id|
        result.serial = id
      end

      opts.on "-m", "--match REGEXP", "Match note using regexp, specific branch only." do |regexp|
        result.regexp = /#{Regexp.escape regexp}/
      end

      opts.on "-t", "--tangent NAME", "Use named Tangent specifically." do |name|
        result.name = name
      end

      opts.on "-x", "--text TEXT", "Text to use for note." do |text|
        result.text = text
      end

      opts.on "-v", "--verbose", "Give extra information for some actions." do
        result.verbose = true
      end

      opts.on "-J", "--json", "JSON output" do
        result.format = :json
      end

      opts.on "-Y", "--yaml", "YAML output" do
        result.format = :yaml
      end


      # Bookkeeping stuff

      opts.on_tail "-h", "--help", "Display this message." do
        puts opts
        exit!
      end

    end.parse! arguments

  rescue OptionParser::InvalidOption => e
    $stderr.print "\n#{e.message}\n\n"
    parse_from %w[ -h ]

  else
    result.rest = arguments
    result.action = :scribe unless result.action
    result
  end

end
