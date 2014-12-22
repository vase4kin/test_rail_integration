require_relative 'test_rail_tools'
require_relative 'test_case_result'
require_relative 'API_client'

module TestRail
  class Connection

    ASSIGNED_TO     ||= TestRailTools.testrail_data[:assigned_to]
    TEST_SUITE      ||= TestRailTools.testrail_data[:test_suite]
    CONNECTION_DATA ||= TestRailTools.testrail_data[:connection_data]
    PROJECT_ID      ||= TestRailTools.testrail_data[:project]
    TEST_RUN_ID ||= TestRailTools.testrail_data[:test_run_id]
    IN_PROGRESS ||= TestRailTools.testrail_data[:in_progress]
    NO_TEST_RAIL    ||= 0


    def self.client
      @client_test_rail ||= TestRail::APIClient.new(CONNECTION_DATA)
    end

    def self.commit_test_result(test_case_result)
      client.send_post("add_result_for_case/#{TEST_RUN_ID}/#{test_case_result.test_case_id}", test_case_result.to_test_rail_api)
    end

    def self.get_test_result(case_id)
      client.send_get("get_results_for_case/#{test_run_id}/#{case_id}")
    end

    def self.get_previous_test_result(case_id)
      test_results = get_test_result(case_id).map { |status_hash| status_hash["status_id"] }
      status       = TestCaseResult::FAILED if test_results.include?(TestCaseResult::FAILED)
      status       ||= TestCaseResult::PASS if test_results.first == TestCaseResult::PASS
      status       ||= TestCaseResult::NEW
      status
    end

    def self.cases_id(test_run_id)
      cases = client.send_get("get_tests/#{test_run_id}")
      cases.map { |test_case| test_case["case_id"] }
    end

    def self.test_run_id=(test_run_id)
      @test_run_id = test_run_id
    end

    def self.test_run_id
      @test_run_id ||= TEST_RUN_ID
    end

    def self.test_run_data
      client.send_get("get_run/#{test_run_id}")
    end

    def self.test_run_name
      test_run_data["name"]
    end

    def self.change_test_run_name
      new_name = test_run_name.gsub(IN_PROGRESS, "")
      client.send_post("update_run/#{test_run_id}", { name: new_name })
    end
  end
end
