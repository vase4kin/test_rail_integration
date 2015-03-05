require_relative 'test_rail_data_load'
require_relative 'connection'
require_relative 'test_run_parameters'

module TestRail
  class TestRailTools

    #
    # Method generates executable cucumber file
    #
    # generate_cucumber_execution_file(2)
    #
    # cucumber -p profile.vn.live_test TESTRAIL=1 --color -f json -o cucumber.json -t  @C666,@C777,@C555
    #
    # change this method for create your own cucumber executable
    #
    def self.generate_cucumber_execution_file(id_of_run, env = nil)
      parameters = TestRunParameters.new(env)
      #TODO do smth with weird replacement
      command = parameters.command.gsub("\#{parameters.venture}", parameters.venture).gsub("\#{parameters.environment}", parameters.environment) + Connection.cases_id(id_of_run).map { |id| "@C"+id.to_s }.join(",")
      cucumber_file = File.new("cucumber_run.sh", "w")
      cucumber_file.chmod(0700)
      cucumber_file.write("#!/bin/sh\n")
      cucumber_file.write(command)
      cucumber_file.close
    end

    #
    # Writing test run ID into test rail data file
    #
    def self.write_test_run_id(test_run_id)
      test_rail_data_file = File.read(TestRailDataLoad::TEST_RAIL_FILE_CONFIG_PATH).gsub(/^:test_run_id:.*/, ":test_run_id: #{test_run_id}")
      config_file = File.open(TestRailDataLoad::TEST_RAIL_FILE_CONFIG_PATH, "w")
      config_file.write (test_rail_data_file)
      config_file.close
    end

    #
    # Preparation for create right cucumber executable file
    #
    def self.prepare_config(run_id, env = nil)
      Connection.test_run_id = run_id
      write_test_run_id(run_id)
      generate_cucumber_execution_file(run_id, env)
    end
  end
end

