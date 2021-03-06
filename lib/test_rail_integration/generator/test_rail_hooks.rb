require 'test_rail_integration/generator/connection'

module TestRail
  class Hook

    TEST_RAIL_ID_REGEX ||= /^@C\d+/

    #
    # Updating Test Rail according to logic
    #
    def self.update_test_rail(scenario)
      test_case_id = scenario.source_tag_names.find { |e| e.match(TEST_RAIL_ID_REGEX) }[2..-1]

      prev_result = TestRail::Connection.get_previous_test_result(test_case_id)
      run_result = scenario.passed?
      test_case_result = TestRail::TestCaseResult.new(test_case_id, scenario.title)

      test_case_result.comment = TestRail::TestCaseResult::COMMENT[:pass] if passed_result?(run_result, prev_result)
      test_case_result.comment ||= TestRail::TestCaseResult::COMMENT[:unchanged_pass] if unchanged_pass_result?(run_result, prev_result)

      if failed_result?(run_result)
        test_case_result.comment ||= TestRail::TestCaseResult::COMMENT[:fail]
        test_case_result.exception_message = scenario.steps.exception rescue nil
        test_case_result.assign_to = TestRail::TestCaseResult::ASSIGN_TO
      end

      raise("Invalid test case result : scenario.passed? #{scenario.passed?}, prev_result? #{prev_result}, run_result? #{run_result}") if test_case_result.comment.nil?

      TestRail::Connection.commit_test_result(test_case_result)

    end

    def self.failed_result?(result)
      !result
    end

    def self.passed_result?(result, prev_result)
      result && prev_result != TestRail::TestCaseResult::FAILED
    end

    def self.unchanged_pass_result?(result, prev_result)
      result && prev_result == TestRail::TestCaseResult::FAILED
    end

    at_exit do
      TestRail::Connection.change_test_run_name
    end
  end
end
