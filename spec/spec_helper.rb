$LOAD_PATH << "#{File.dirname(__FILE__)}/../lib"

require "oughtve"

# Sandbox, see spec.rb.
Oughtve.run %w[ --setup ]

