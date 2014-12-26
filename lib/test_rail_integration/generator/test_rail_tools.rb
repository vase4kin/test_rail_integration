require 'yaml'
require_relative 'connection'
require_relative 'test_run_parameters'

module TestRail
  class TestRailTools

    CONFIG_PATH ||= ('config/data/test_rail_data.yml')

    def self.test_rail_data
      YAML.load(File.open(CONFIG_PATH))
    end

    def self.generate_cucumber_execution_file(id_of_run)
      parameters    = TestRunParameters.new
      command       = "cucumber -p lazada.#{parameters.venture}.#{parameters.environment} TESTRAIL=1 --color -f json -o cucumber.json -t  " + Connection.cases_id(id_of_run).map { |id| "@C"+id.to_s }.join(",")
      cucumber_file = File.new("cucumber_run.sh", "w")
      cucumber_file.chmod(0700)
      cucumber_file.write("#!/bin/sh\n")
      cucumber_file.write(command)
      cucumber_file.close
    end

    def self.write_test_run_id(test_run_id)
      testrail_data_file = File.read(CONFIG_PATH).gsub(/^:test_run_id: \d+/, ":test_run_id: #{test_run_id}")
      config_file        = File.open(CONFIG_PATH, "w")
      config_file.write (testrail_data_file)
      config_file.close
    end

    def self.prepare_config(run_id)
      Connection.test_run_id = run_id
      write_test_run_id(run_id)
      generate_cucumber_execution_file(run_id)
    end
  end
end

