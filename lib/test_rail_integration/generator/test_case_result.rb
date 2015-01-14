require_relative 'test_rail_data_load'

module TestRail
  class TestCaseResult

    attr_accessor :test_case_id, :title, :comment, :exception_message

    COMMENT_STATUS ||= TestRail::TestRailDataLoad.test_rail_data[:status_comment]
    PASS           ||= TestRail::TestRailDataLoad.test_rail_data[:test_pass]
    FAILED         ||= TestRail::TestRailDataLoad.test_rail_data[:test_failed]
    NEW            ||= TestRail::TestRailDataLoad.test_rail_data[:new_test]
    PASS_COMMENT   ||= TestRail::TestRailDataLoad.test_rail_data[:test_passed_comment]
    FAILED_COMMENT ||= TestRail::TestRailDataLoad.test_rail_data[:test_failed_comment]

    COMMENT ||= { :pass           => { status: PASS, comment: PASS_COMMENT },
                  :fail           => { status: FAILED, comment: FAILED_COMMENT },
                  :unchanged_pass => { status: COMMENT_STATUS, comment: PASS_COMMENT }
    }

    def initialize(test_case_id, title)
      self.test_case_id = test_case_id
      self.title        = title
    end

    #
    # Send status to TestRail
    #
    # {status_id: 1, comment: "Test passed"}
    #
    def to_test_rail_api
      comment_message = "\"#{self.title}\" #{self.comment[:comment]}"
      comment_message += "\n Exception : #{self.exception_message}" unless self.exception_message.nil?
      if  self.comment[:status] == COMMENT_STATUS
        { comment: comment_message }
      else
        { status_id: self.comment[:status], comment: comment_message }
      end
    end

  end
end