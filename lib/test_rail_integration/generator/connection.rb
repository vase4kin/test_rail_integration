require_relative 'test_rail_data_load'
require_relative 'API_client'
require_relative 'test_case_result'

module TestRail
  class Connection

    ASSIGNED_TO ||= TestRailDataLoad.test_rail_data[:assigned_to]
    TEST_SUITE ||= TestRailDataLoad.test_rail_data[:test_suite]
    CONNECTION_DATA ||= TestRailDataLoad.test_rail_data[:connection_data]
    PROJECT_ID ||= TestRailDataLoad.test_rail_data[:project]
    TEST_RUN_ID ||= TestRailDataLoad.test_rail_data[:test_run_id]
    IN_PROGRESS ||= TestRailDataLoad.test_rail_data[:in_progress]
    TYPES ||= TestRailDataLoad.test_rail_data[:types]
    NO_TEST_RAIL ||= 0

    #
    # Creates connection to TestRail server
    #
    # client = TestRail::APIClient.new('<TestRail server>',"<User email>","<User password>")
    #
    def self.client
      @client_test_rail ||= TestRail::APIClient.new(CONNECTION_DATA)
    end

    #
    # Send test result to TestRail for current test run
    # client.send_post("add_result_for_case/<number_of test run>/<test case id>", <result that pushes>)
    #
    # client.send_post("add_result_for_case/12/3131", status_id: '1', comment: "Test passed" )
    #
    def self.commit_test_result(test_case_result)
      client.send_post("add_result_for_case/#{TEST_RUN_ID}/#{test_case_result.test_case_id}", test_case_result.to_test_rail_api)
    end

    #
    # Obtaining of all previous test results for current test case
    #
    # client.send_get("get_results_for_case/12/3534")
    #
    def self.get_test_results(case_id)
      client.send_get("get_results_for_case/#{test_run_id}/#{case_id}")
    end

    #
    # Create test run in test rail for project with name
    #
    def self.create_test_run_with_name(name)
      client.send_post("add_run/#{project_id}", {suite_id: test_suite_id, name: name, include_all: false, case_ids: cases_with_types})
    end

    #
    # Get ID of all test cases from current test run
    #
    # cases = client.send_get("get_tests/12")
    #
    def self.cases_id(test_run_id)
      cases = client.send_get("get_tests/#{test_run_id}")
      cases.map { |test_case| test_case["case_id"] }
    end

    #
    # Setting up test run id
    #
    def self.test_run_id=(test_run_id)
      @test_run_id = test_run_id
    end

    #
    # Setting test run id value
    #
    def self.test_run_id
      @test_run_id ||= TEST_RUN_ID
    end

    #
    # Setting project id
    #
    def self.project_id
      @project_id ||= PROJECT_ID
    end


    #
    # Setting test suite id
    #
    def self.test_suite_id
      @test_suite_id ||= TEST_SUITE
    end

    #
    # Getting information about test run
    #
    def self.test_run_data(id_of_run=test_run_id)
      client.send_get("get_run/#{id_of_run}")
    end

    #
    # Get test run name
    #
    def self.test_run_name(id_of_run=test_run_id)
      test_run_data(id_of_run)["name"]
    end

    #
    # Take all test types
    #
    def self.cases_with_types
      types = TYPES
      cases = client.send_get("get_cases/#{project_id}&suite_id=#{test_suite_id}&type_id=#{types}")
      case_ids = cases.map { |test_case| test_case["id"] }
      case_ids
    end

    #
    # Changing name of test run from <test run name> in progress to <test run name>
    #
    # VN LIVE_TEST in progress => VN LIVE_TEST
    #
    def self.change_test_run_name(run_id = test_run_id)
      new_name = test_run_name.gsub(IN_PROGRESS, "")
      client.send_post("update_run/#{run_id}", {name: new_name})
    end

    #
    # Send request for creation test run with name
    # ("add_run/3", {suite_id: 3, name "New test run", include_all: false, case_ids: C31, C32, C33}
    #
    def self.create_new_test_run_with_name
      client.send_post("add_run/#{project_id}", {suite_id: test_suite_id, name: generate_test_run_name, include_all: false, case_ids: cases_with_types})
    end

    #
    # Get all test runs for project
    #
    def self.get_test_runs
      client.send_get("get_runs/#{project_id}")
    end

    #
    # Generate name for test run with date
    #
    def self.generate_test_run_name
      "Test run #{Time.now.strftime("%d/%m/%Y")}"
    end

  end
end
