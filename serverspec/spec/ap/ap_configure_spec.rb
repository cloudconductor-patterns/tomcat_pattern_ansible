require 'spec_helper'

describe service('tomcat7') do
  it { should be_running }
end

describe port(8009) do
  it { should be_listening } # with tcp on ipv4 or ipv6
end
