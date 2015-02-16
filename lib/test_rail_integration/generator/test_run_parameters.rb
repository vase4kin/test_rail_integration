require_relative 'API_client'

module TestRail
  class TestRunParameters
    VENTURE_REGEX     ||= TestRail::TestRailDataLoad.test_rail_data[:ventures]
    ENVIRONMENT_REGEX ||= TestRail::TestRailDataLoad.test_rail_data[:environments]
    CHECK_TEST_RUN_NAME ||= TestRail::TestRailDataLoad.test_rail_data[:check_test_run_name]
    EXEC_COMMAND ||= TestRail::TestRailDataLoad.test_rail_data[:exec_command]

    attr_accessor :environment, :venture, :command

    #
    # Checking of correct naming of created test run and return parameters for running test run
    #
    def initialize
      if CHECK_TEST_RUN_NAME
        parameters = Connection.test_run_name.downcase.match(/(#{VENTURE_REGEX}) (#{ENVIRONMENT_REGEX})*/)
        begin
          @venture = parameters[1]
          @environment = parameters[2]
          @command = EXEC_COMMAND
        rescue Exception
          raise ("The test run name is not valid. Format: 'venture env description'")
        end
      else
        @command ||= EXEC_COMMAND
      end
    end
  end
end