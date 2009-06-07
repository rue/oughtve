# Ensure this current set is before any installed ones
#
$LOAD_PATH.unshift "#{File.dirname(__FILE__)}/../lib"

require "oughtve"

# Sandbox, see spec.rb.
Oughtve.run %w[ --bootstrap ]

