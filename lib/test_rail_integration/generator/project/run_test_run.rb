#!/usr/bin/env ruby
require 'test_rail_integration'
require 'thor'
require 'test_rail_integration/generator/test_rail_tools'

module TestRail
  create_test_rail_data_file
  id_of_run = ARGV.shift
  TestRailTools.prepare_config(id_of_run)
end

