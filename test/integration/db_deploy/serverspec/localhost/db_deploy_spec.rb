require 'spec_helper'

describe 'db_deploy' do
  it 'is postgresql service enabled and running' do
    expect(service('postgresql-9.4')).to be_enabled.and be_running
  end
end
