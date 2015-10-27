require 'spec_helper'
require 'json'

describe 'web_setup' do
  it 'is installed apache package' do
    expect(package('httpd')).to be_installed
  end

  it 'is s apache service enabled and running' do
    expect(service('httpd')).to be_enabled.and be_running
  end

  it 'is installed apache devel package' do
    expect(package('httpd-devel')).to be_installed
  end

  it 'is exist a mod_jk.so file' do
    expect(file('/usr/lib64/httpd/modules/mod_jk.so')).to be_file
    # node['kernel']['machine'] =~ /^i[36]86$/ ? '/usr/lib/httpd' : '/usr/lib64/httpd'
  end

  it 'is exist a workers.properties file' do
    expect(file('/etc/httpd/conf/workers.properties')).to be_file
  end

  it 'is exist a uriworkermap.properties file' do
    expect(file('/etc/httpd/conf//uriworkermap.properties')).to be_file
  end

  it 'is mod-jk.conf file set given mode, owned by a given user, grouped in to a given group, and exist' do
    expect(file('/etc/httpd/conf-available/mod-jk.conf'))
      .to be_file.and be_mode(664).and be_owned_by('apache').and be_grouped_into('apache')
  end

  it 'is conf-enabled/mod-jk.conf are linked to conf-available/mod-jk.conf' do
    expect(file('/etc/httpd/conf-enabled/mod-jk.conf'))
      .to be_linked_to '/etc/httpd/conf-available/mod-jk.conf'
  end
end
