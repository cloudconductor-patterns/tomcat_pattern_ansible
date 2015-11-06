require 'spec_helper'

describe 'web_deploy' do
  it 'apache service is running' do
    expect(service('httpd')).to be_running
  end

  it 'apache service listening port is tcp' do
    %w(80).each do |listen_port|
      expect(port(listen_port)).to be_listening.with('tcp')
    end
  end
end
