require 'spec_helper'

describe 'ap_default' do
  it 'is tomcat service enabled and running' do
    expect(service('tomcat7')).to be_enabled.and be_running
  end
end
