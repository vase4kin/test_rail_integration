#!/usr/bin/env ruby
require 'test_rail_integration'
require 'thor'
require 'test_rail_integration/generator/API_client'

module TestRail
  p TestRailIntegration::TestTail::Generators::Project.test_rail_data_file_exist?
  if TestRailIntegration::TestTail::Generators::Project.test_rail_data_file_exist?
    id_of_run = ARGV.shift
    TestRailTools.prepare_config(id_of_run)
  else
    TestRailIntegration::TestTail::Generators::Project.copy_file("test_rail_data.yml", "config/data")
    raise "Please fill all required data in test rail data yml file"
  end
end

