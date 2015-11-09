require 'spec_helper'

describe 'db_deploy' do
  db_user = 'user'
  db_name = 'application'

  it 'is postgresql service enabled and running' do
    expect(service('postgresql-9.4')).to be_enabled.and be_running
  end
end
