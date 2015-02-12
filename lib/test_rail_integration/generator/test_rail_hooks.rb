require 'test_rail_integration/generator/connection'

module TestRail
  class Hook

    TEST_RAIL_ID_REGEX ||= /^@C\d+/


    def self.update_test_rail(scenario)
      test_case_id = scenario.source_tag_names.find { |e| e.match(TEST_RAIL_ID_REGEX) }[2..-1]

      prev_result              = TestRail::Connection.get_previous_test_result(test_case_id)
      test_case_result         = TestRail::TestCaseResult.new(test_case_id, scenario.title)

      test_case_result.comment = TestRail::TestCaseResult::COMMENT[:pass] if passed_result?( prev_result )
      test_case_result.comment ||= TestRail::TestCaseResult::COMMENT[:unchanged_pass] + "\n" + TestRail::Connection.get_previous_comment(test_case_id) if unchanged_pass_result?( prev_result )

      if failed_result?
        test_case_result.comment ||= TestRail::TestCaseResult::COMMENT[:fail]  + "\n" + TestRail::Connection.get_previous_comment(test_case_id)
        test_case_result.exception_message = scenario.steps.exception rescue nil
        test_case_result.assign_to = TestRail::TestCaseResult::ASSIGN_TO
      end
    end

    def self.failed_result?( result )
      !result
    end

    def self.passed_result?( result )
      result != TestRail::TestCaseResult::FAILED
    end

    def self.unchanged_pass_result?( result )
      result == TestRail::TestCaseResult::FAILED
    end

    at_exit do
      TestRail::Connection.change_test_run_name
    end
  end
end
