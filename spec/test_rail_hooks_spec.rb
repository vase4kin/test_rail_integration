require 'spec_helper'
require_relative '../lib/test_rail_integration/generator/test_rail_hooks'

describe 'Test test rail hooks' do

  before(:each) do
    allow(TestRail::Connection).to receive(:get_indexes_of_fails).and_return([])
    allow(TestRail::Connection).to receive(:get_previous_test_result).and_return(@test_case_result)
    allow(TestRail::Connection).to receive(:commit_test_result).and_return('good!')
    @scenario = double('scenario')
    allow(@scenario).to receive(:source_tag_names).and_return(['@C4556'])
    allow(@scenario).to receive(:title).and_return('title')
    allow(@scenario).to receive(:passed?).and_return(true)
    @test_case_result = TestRail::TestCaseResult.new('4567', 'title', @scenario)
  end

  it 'test that test rail data with passed result is correct' do
    expect(TestRail::Hook.update_test_rail(@scenario).test_case_id).to eq('4556')
    expect(TestRail::Hook.update_test_rail(@scenario).title).to eq('title')
    expect(TestRail::Hook.update_test_rail(@scenario).comment).to eq({:status=>1, :comment => 'test **passed:**'})
  end
end