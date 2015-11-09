require 'spec_helper'

describe 'ap_default' do
  it 'is created context xml' do
    expect(file('/etc/tomcat7/Catalina/localhost/jpetstore.xml'))
      .to be_file
      .and be_owned_by('tomcat')
  end

  it 'is tomcat service enabled and running' do
    expect(service('tomcat7')).to be_enabled.and be_running
  end
end
