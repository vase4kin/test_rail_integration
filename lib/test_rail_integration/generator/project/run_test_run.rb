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
  #TODO Make Hash instead of array for parameters
  if parameters[0] == 'auto'
    environment_for_run = parameters[1], parameters[2]
    id_of_run = TestRunCreation.initialize_test_run
  else
    id_of_run = parameters[0].to_i
    name_of_environment = Connection.test_run_name(id_of_run).downcase.match(/(#{TestRunParameters::VENTURE_REGEX}) (#{TestRunParameters::ENVIRONMENT_REGEX})*/)
    environment_for_run = name_of_environment[1], name_of_environment[2] if name_of_environment
  end
  TestRailTools.prepare_config(id_of_run, environment_for_run)
end

