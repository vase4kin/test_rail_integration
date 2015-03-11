require_relative 'test_rail_data_load'
require_relative 'connection'

module TestRail
  class TestCaseResult

    attr_accessor :test_case_id, :title, :comment, :exception_message, :assign_to, :previous_comment, :previous_result, :scenario

    COMMENT_STATUS ||= TestRail::TestRailDataLoad.test_rail_data[:status_comment]
    PASS ||= TestRail::TestRailDataLoad.test_rail_data[:test_pass]
    FAILED ||= TestRail::TestRailDataLoad.test_rail_data[:test_failed]
    NEW ||= TestRail::TestRailDataLoad.test_rail_data[:new_test]
    PASS_COMMENT ||= TestRail::TestRailDataLoad.test_rail_data[:test_passed_comment]
    FAILED_COMMENT ||= TestRail::TestRailDataLoad.test_rail_data[:test_failed_comment]
    ASSIGN_TO ||= TestRail::TestRailDataLoad.test_rail_data[:assign_to]


    COMMENT ||= {:pass => {status: PASS, comment: PASS_COMMENT},
                 :fail => {status: FAILED, comment: FAILED_COMMENT},
                 :unchanged_pass => {status: COMMENT_STATUS, comment: PASS_COMMENT}
    }

    def initialize(test_case_id, title, scenario)
      self.test_case_id = test_case_id
      self.title = title
      self.scenario = scenario
      # TODO call get_test_result one time
      self.previous_comment = TestRail::Connection.get_last_failed_comment(test_case_id) unless TestRail::Connection.get_indexes_of_fails(test_case_id).empty?
      self.previous_result = TestRail::Connection.get_previous_test_result(test_case_id)
    end

    #
    # Send status to TestRail
    #
    # {status_id: 1, comment: "Test passed"}
    #
    def to_test_rail_api
      comment_message = "#{self.comment[:comment]} \"#{self.title}\""
      comment_message += "\n Exception : #{self.exception_message}" unless self.exception_message.nil?
      comment_message += "\n #{self.previous_comment}" if self.comment[:status] == COMMENT[:fail][:status] || self.comment[:status] == COMMENT[:unchanged_pass][:status]
      if self.comment[:status] == COMMENT_STATUS
        {comment: comment_message}
      else
        {status_id: self.comment[:status], comment: comment_message}
      end
    end

    def failed?
      !scenario.passed?
    end

    def passed?
      scenario.passed? && previous_result != FAILED
    end

    def unchanged_pass?
      scenario.passed? && previous_result == FAILED
    end

    def status_update
      self.comment = COMMENT[:pass] if passed?
      self.comment ||= COMMENT[:unchanged_pass] if unchanged_pass?

      if failed?
        self.comment ||= COMMENT[:fail]
        self.exception_message = self.scenario.steps.exception rescue nil
        self.assign_to = ASSIGN_TO
      end

      raise("Invalid test case result : scenario.passed? #{scenario.passed?}, prev_result? #{previous_result}, run_result? #{scenario}") if comment.nil?
    end

  end
end