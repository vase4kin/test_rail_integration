require 'test_rail_integration/generator/connection'

module TestRail
  class Hook

    #
    # Updating Test Rail according to logic
    #
    def self.update_test_rail(scenario)
      test_case_result = TestRail::TestCaseResult.new(scenario)
      test_case_result.status_update
      TestRail::Connection.commit_test_result(test_case_result)
      test_case_result
    end

    at_exit do
      TestRail::Connection.change_test_run_name
    end
  end
end
