require 'spec_helper'

describe 'web_configure' do
  it 'is apache service is running ' do
    expect(service('httpd')).to be_running
  end

  it 'is apache ports is listning' do
    %w(80).each do |listen_port|
      expect(port(listen_port)).to be_listening.with('tcp')
    end
  end

  it 'is workers.properties file set mode and exist' do
    expect(file('/etc/httpd/conf.d/workers.properties'))
      .to be_file
      .and be_mode(644)
  end

  it 'is mod-jk.conf file exist' do
    expect(file('/etc/httpd/conf.d/httpd-jk.conf'))
      .to be_file
  end
end
