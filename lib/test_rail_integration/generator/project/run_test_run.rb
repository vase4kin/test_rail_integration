#!/usr/bin/env ruby
require 'test_rail_integration/generator/test_rail_data_load'
require 'test_rail_integration'
require 'thor'
require 'test_rail_integration/generator/API_client'
require 'test_rail_integration/generator/connection'
require 'test_rail_integration/generator/test_run_creation'
require 'test_rail_integration/generator/test_rail_tools'

module TestRail
  unless TestRailIntegration::TestTail::Generators::Project.test_rail_data_file_exist?
    TestRailIntegration::TestTail::Generators::Project.copy_file("test_rail_data.yml")
    raise "Please fill all required data in test rail data yml file"
  end

  parameters = ARGV
  id_of_run = parameters[0].to_i
  environment_for_run = parameters[1], parameters[2] if parameters.length > 1
  if parameters[3] == 'auto'
    TestRailTools.change_checking_of_test_run(false)
    TestRailTools.write_environment_for_run(environment_for_run)
    TestRunCreation.initialize_test_run
  else
    TestRailTools.prepare_config(id_of_run)
  end
end

