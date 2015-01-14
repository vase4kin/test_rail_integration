require_relative 'test_rail_data_load'
require_relative 'API_client'
require_relative 'test_case_result'

module TestRail
  class Connection

    ASSIGNED_TO     ||= TestRailDataLoad.test_rail_data[:assigned_to]
    TEST_SUITE      ||= TestRailDataLoad.test_rail_data[:test_suite]
    CONNECTION_DATA ||= TestRailDataLoad.test_rail_data[:connection_data]
    PROJECT_ID      ||= TestRailDataLoad.test_rail_data[:project]
    TEST_RUN_ID     ||= TestRailDataLoad.test_rail_data[:test_run_id]
    IN_PROGRESS     ||= TestRailDataLoad.test_rail_data[:in_progress]
    NO_TEST_RAIL    ||= 0

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
    def self.get_test_result(case_id)
      client.send_get("get_results_for_case/#{test_run_id}/#{case_id}")
    end

    #
    # Parse results and returns Failed if this test was marked as failed.
    #
    def self.get_previous_test_result(case_id)
      test_results = get_test_result(case_id).map { |status_hash| status_hash["status_id"] }
      status       = TestCaseResult::FAILED if test_results.include?(TestCaseResult::FAILED)
      status       ||= TestCaseResult::PASS if test_results.first == TestCaseResult::PASS
      status       ||= TestCaseResult::NEW
      status
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
    # Getting test run id value
    #
    def self.test_run_id
      @test_run_id ||= TEST_RUN_ID
    end

    #
    # Getting information about test run
    #
    def self.test_run_data
      client.send_get("get_run/#{test_run_id}")
    end

    #
    # Get test run name
    #
    def self.test_run_name
      test_run_data["name"]
    end

    #
    # Changing name of test run from <test run name> in progress to <test run name>
    #
    # VN LIVE_TEST in progress => VN LIVE_TEST
    #
    def self.change_test_run_name
      new_name = test_run_name.gsub(IN_PROGRESS, "")
      client.send_post("update_run/#{test_run_id}", { name: new_name })
    end
  end
end
