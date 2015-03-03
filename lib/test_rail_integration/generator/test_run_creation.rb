require_relative 'test_rail_data_load'
require_relative 'connection'
require_relative 'test_run_parameters'

module TestRail
  class TestRunCreation

    #
    # Get all test run names for project
    #
    def self.get_test_runs_names
      test_runs = Connection.get_test_runs
      test_runs_names = []
      test_runs.each{ | test_run | test_runs_names.push(test_run.fetch("name")) }
      test_runs_names
    end

    #
    # Get id for new test run that we created
    #
    def self.get_created_test_run_id
      test_runs = Connection.get_test_runs
      created_test_run_id = test_runs.map { | test_run |
        test_run.fetch("id") if test_run.fetch("name").eql? Connection.generate_test_run_name
      }
      TestRailTools.write_test_run_id(created_test_run_id.first)
      created_test_run_id.first
    end

    #
    # Checking that test run already created
    #
    def self.check_presence_of_test_run
      TestRunCreation.get_test_runs_names.include? Connection.generate_test_run_name
    end
    #
    # Check and create test run
    #
    def self.initialize_test_run
      unless TestRunCreation.check_presence_of_test_run
        Connection.create_new_test_run_with_name
      end
      TestRunCreation.get_created_test_run_id
      environment = TestRail::TestRailDataLoad.test_rail_data[:env_for_run].split(" ")
      TestRailTools.generate_cucumber_execution_file(TestRunCreation.get_created_test_run_id, environment)
    end

  end

end
