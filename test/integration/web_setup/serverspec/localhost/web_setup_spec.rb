require 'spec_helper'

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
end
