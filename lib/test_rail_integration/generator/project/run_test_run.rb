#!/usr/bin/env ruby
require 'test_rail_integration'
require 'thor'
require 'test_rail_integration/generator/API_client'
require 'test_rail_integration/generator/connection'
require 'test_rail_integration/generator/test_rail_tools'

module TestRail
  unless TestRailIntegration::TestTail::Generators::Project.test_rail_data_file_exist?
    TestRailIntegration::TestTail::Generators::Project.copy_file("test_rail_data.yml")
    raise "Please fill all required data in test rail data yml file"
  end
  id_of_run = ARGV.shift
  TestRailTools.prepare_config(id_of_run)
end

