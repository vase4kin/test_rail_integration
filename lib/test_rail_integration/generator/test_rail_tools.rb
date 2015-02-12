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
      parameters    = TestRunParameters.new
      command       = parameters.command + Connection.cases_id(id_of_run).map { |id| "@C"+id.to_s }.join(",")
      if env
        env_array = env.split(" ")
        auto_command       = parameters.command.gsub("#{parameters.venture}", "#{env_array[0]}").gsub("#{parameters.environment}", "#{env_array[1]}")
        command = auto_command + Connection.cases_id(id_of_run).map { |id| "@C"+id.to_s }.join(",")
      end
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
      test_rail_data_file = File.read(TestRailDataLoad::TEST_RAIL_FILE_CONFIG_PATH).gsub(/^:test_run_id: .*/, ":test_run_id: \"#{test_run_id}\"")
      config_file        = File.open(TestRailDataLoad::TEST_RAIL_FILE_CONFIG_PATH, "w")
      config_file.write (test_rail_data_file)
      config_file.close
    end

    #
    # Writing environment for running test run
    #
    def self.write_environment_for_run(env)
      test_rail_data_file = File.read(TestRailDataLoad::TEST_RAIL_FILE_CONFIG_PATH).gsub(/^:env_for_run: \d+/, ":env_for_run: #{env.join(" ")}")
      config_file        = File.open(TestRailDataLoad::TEST_RAIL_FILE_CONFIG_PATH, "w")
      config_file.write (test_rail_data_file)
      config_file.close
    end

    #
    # Preparation for create right cucumber executable file
    #
    def self.prepare_config(run_id, env = nil)
      Connection.test_run_id = run_id
      write_test_run_id(run_id)
      if env
        write_environment_for_run(env)
      end
      generate_cucumber_execution_file(run_id)
    end
  end
end

