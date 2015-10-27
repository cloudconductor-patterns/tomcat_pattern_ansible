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

  it 'is workers.properties file set given mode, owned by a given user, grouped in to a given group, and exist'do
    expect(file('/etc/httpd/conf/workers.properties'))
      .to be_file
      .and be_mode(664)
      .and be_owned_by('apache')
      .and be_grouped_into('apache')
  end

  it 'is workers.properties file contains the all ap server settings' do
    %w('ap_server').each do |hostname, server|
      expect(file('/etc/httpd/conf/workers.properties'))
        .to contain("worker.#{hostname}.reference=worker.template")
        .and contain("worker.#{hostname}.host=#{server['private_ip']}")
        .and contain("worker.#{hostname}.route=#{server['route']}")
        .and contain("worker.#{hostname}.lbfactor=#{server['weight']}")
    end
  end
end
