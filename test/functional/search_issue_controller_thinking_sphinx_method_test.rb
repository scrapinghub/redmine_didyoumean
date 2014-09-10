require File.expand_path('../../test_helper', __FILE__)
require 'thinking_sphinx/test'
include RedmineDidyoumean

class SearchIssuesControllerTest < ActionController::TestCase

  def setup_ts
    ThinkingSphinx::Test.index
    sleep 0.25 until index_finished?
    settings
  end

  def index_finished?
    Dir[Rails.root.join(ThinkingSphinx::Test.config.indices_location, '*.{new,tmp}.*')].empty?
  end

  def settings
    Setting.destroy_all
    Setting.clear_cache
    Setting['plugin_redmine_didyoumean'] = {
      'show_only_open' => '0',
      'project_filter' => '2',
      'min_world_length' => '2',
      'limit' => '5',
      'start_search_when' => '0',
      'search_method' => '1'
    }
  end

  test 'ts fixtures load?' do
    setup_ts
    assert_equal 1, User.count, 'Wrong users count!'
  end

  test 'ts query_ts' do
    setup_ts
    Rails.logger.debug "-------------------------------------->>>>>>>>>>>>>>>>>>> "
    get :index, project_id: 1, query: 'GUI', format: 'json'
    Rails.logger.debug "-------------------------------------->>>>>>>>>>>>>>>>>>> "
    body = JSON.parse(response.body)
    assert_equal 2, body['total'], 'Wrong number of issues!'
    assert_equal 'GUI issues list', body['issues'].first['subject'], 'Subject is different!'
    assert_equal 'New', body['issues'].first['status_name'], 'Wrong status name!'
    assert_equal 'Graphic design GUI', body['issues'].last['subject'], 'Wrong second issue subject!'
  end

  test 'ts edit existing issue with ts' do
    setup_ts
    get :index, project_id: 1, issue_id: 1, query: 'GUI', format: 'json'
    body = JSON.parse(response.body)
    assert_equal 1, body['total'], 'Wrong total issues!'
  end

  test 'ts destroy issue without errors with ts' do
    setup_ts
    assert_difference 'Issue.count', -1 do
      Issue.first.destroy
    end
  end
end
