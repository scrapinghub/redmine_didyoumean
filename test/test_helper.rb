# Load the normal Rails helper
require File.expand_path(File.dirname(__FILE__) + '/../../../test/test_helper')

class ActionController::TestCase

  fixtures :projects, :issues, :users, :settings, :members, :roles, :enabled_modules, :issue_statuses, :trackers
  ActiveRecord::Fixtures.create_fixtures(File.dirname(__FILE__) + '/fixtures/',
                                         [:projects,
                                          :issues,
                                          :users,
                                          :settings,
                                          :members,
                                          :roles,
                                          :enabled_modules,
                                          :issue_statuses,
                                          :trackers])
end
