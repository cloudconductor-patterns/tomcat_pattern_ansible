require 'spec_helper'

describe 'ap_default' do
  it 'is installed yum-priorities' do
    expect(package('yum-plugin-priorities')).to be_installed
  end

  it 'is installed jpackage-release-6-3.jpp6.noarch' do
    expect(package('jpackage-release-6-3.jpp6.noarch')).to be_installed
  end

  it 'is replace gpgcheck to 0' do
    expect(file('/etc/yum.repos.d/jpackage.repo'))
      .to be_file
      .and contain('gpgcheck=0')
  end

  it 'is installed jdk' do
    expect(package('java-1.7.0-openjdk')).to be_installed
    expect(package('java-1.7.0-openjdk-devel')).to be_installed
  end

  it 'is installed tomcat' do
    expect(package('tomcat7')).to be_installed
  end

  it 'is tomcat directory own is tomcat' do
    expect(file('/usr/share/tomcat7'))
      .to be_directory
      .and be_owned_by('tomcat')
  end

  it 'is installed jdbc driver' do
    expect(file('/usr/share/tomcat7/lib/postgresql-9.4-1201.jdbc41.jar')).to be_file
  end

  it 'is created context xml' do
    expect(file('/etc/tomcat7/Catalina/localhost/jpetstore.xml'))
      .to be_file
      .and be_owned_by('tomcat')
  end

  it 'is tomcat service enabled and running' do
    expect(service('tomcat7')).to be_enabled.and be_running
  end
end
