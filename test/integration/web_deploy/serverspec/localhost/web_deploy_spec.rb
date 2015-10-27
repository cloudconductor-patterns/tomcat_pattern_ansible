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

  it 'apache configuration file is exists' do
    expect(file('/etc/httpd/conf/uriworkermap.properties'))
      .to be_file
      .and be_mode(664)
      .and be_owned_by('apache')
      .and be_grouped_into('apache')
  end

  it 'loadbalancer config is found into apache configuration file' do
    %w('application').each do |name|
      expect(file('/etc/httpd/conf/uriworkermap.properties'))
        .to contain("/#{name}=loadbalancer")
        .and contain("/#{name}/*=loadbalancer")
    end
  end
end
