#!/usr/bin/env ruby
require 'test_rail_integration'

module TestRail
  id_of_run = ARGV.shift
  TestRailTools.prepare_config(id_of_run)
end

