#!/usr/bin/env ruby
require 'test_rail_integration'

module TestRail
  unless Generators::Project.test_rail_data_file_exist?
  Generators::Project.copy_test_rail_data_yml
  raise "Please fill all required data in test rail data yml file"
  end
  id_of_run = ARGV.shift
  TestRailTools.prepare_config(id_of_run)
end

