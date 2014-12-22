require_relative 'API_client'

module TestRail
  class TestRunParameters
    VENTURE_REGEX ||= /vn|id|ph|my|sg|th/
    ENVIRONMENT_REGEX ||= /live_test|staging|showroom/

    attr_accessor :environment, :venture

    def initialize
      parameters = Connection.test_run_name.downcase.match(/^(#{VENTURE_REGEX}) (#{ENVIRONMENT_REGEX})*/)
      begin
        @venture     = parameters[1]
        @environment = parameters[2]
      rescue Exception
        raise ("The test run name is not valid. Format: 'venture env description'")
      end
    end
  end
end