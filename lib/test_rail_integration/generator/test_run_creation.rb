require_relative 'test_rail_data_load'
require_relative 'connection'
require_relative 'test_run_parameters'

module TestRail
  class TestRunCreation

    #
    # Send request for creation test run with name
    # ("add_run/3", {suite_id: 3, name "New test run", include_all: false, case_ids: C31, C32, C33}
    #
    def self.create_new_test_run_with_name
      client.send_post("add_run/#{test_run_id}", { suite_id: test_suite_id, name: generate_test_run_name, include_all: false, case_ids: cases_with_types })
    end

    #
    # Get all test runs for project
    #
    def get_test_runs
      client.send_get("get_runs/#{project_id}")
    end

    #
    # Get all test run names for project
    #
    def get_test_runs_names
      test_runs = get_test_runs
      test_runs_names = []
      test_runs.each{ | test_run | test_runs_names.push(test_run.fetch("name")) }
      test_runs_names
    end

    #
    # Get id for new test run that we created
    #
    def self.get_created_test_run_id
      test_runs = get_test_runs
      test_runs.map { | test_run |
        created_test_run_id = test_run.fetch("id") if test_run.fetch("name").eql? generate_test_run_name
      }
      TestRailTools.prepare_config(created_test_run_id)
    end

    #
    # Generate name for test run with date
    #
    def self.generate_test_run_name
      "Automation testrun #{Time.now.strftime("%d/%m/%Y")}"
    end

    #
    # Checking that test run already created
    #
    def check_presence_of_test_run
      get_test_runs_names.include? generate_test_run_name
    end

    #
    # Check and create test run
    #
    def self.initialize_test_run
      if check_presence_of_test_run
        get_created_test_run_id
      else
        create_new_test_run_with_name
      end
    end

  end

end
