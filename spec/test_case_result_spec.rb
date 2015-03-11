require 'spec_helper'
require_relative '../lib/test_rail_integration/generator/test_case_result'

describe 'Test case result class testing' do

  before(:each) do
    allow(TestRail::Connection).to receive(:get_test_results).and_return([])
    @scenario = double('scenario')
    allow(@scenario).to receive(:source_tag_names).and_return(['@C4556'])
    allow(@scenario).to receive(:title).and_return('title')
    allow(@scenario).to receive(:passed?).and_return(true)
    @result = TestRail::TestCaseResult.new('id', 'title', @scenario)
  end

  xit 'test that test rail test case result with no fails generate correct json' do
    @result.comment = TestRail::TestCaseResult::COMMENT[:pass]
    expect(@result.to_test_rail_api).to eq({:status_id => 1, :comment => "test **passed:** \"title\""})
  end

  xit 'test that test rail case result has comment equal COMMENT_STATUS' do
    @result.comment = TestRail::TestCaseResult::COMMENT[:pass]
    @result.comment[:status] =  TestRail::TestCaseResult::COMMENT_STATUS
    expect(@result.to_test_rail_api).to eq({:comment => "test **passed:** \"title\"\n "})
  end

  after(:each) do
    allow(TestRail::Connection).to receive(:get_test_results).and_call_original
  end

end