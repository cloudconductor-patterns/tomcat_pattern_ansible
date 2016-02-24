require 'spec_helper'
require 'unix_crypt'

describe port(5432) do
  it { should be_listening.with('tcp') }
end

describe 'postgresql server' do
  hostname = '127.0.0.1'
  port = '5432'

  params = property[:consul_parameters]

  app_db = if params[:tomcat_pattern_ansible] &&
              params[:tomcat_pattern_ansible][:database] &&
              params[:tomcat_pattern_ansible][:database][:db_name]

             params[:tomcat_pattern_ansible][:database][:db_name]
           else
             'application'
           end

  app_user = if params[:tomcat_pattern_ansible] &&
                params[:tomcat_pattern_ansible][:database] &&
                params[:tomcat_pattern_ansible][:database][:db_user]

               params[:tomcat_pattern_ansible][:database][:db_user]
             else
               'user'
             end

  app_passwd = if params[:cloudconductor][:salt]
                 UnixCrypt::SHA256.build(params[:cloudconductor][:salt], 'password')
               else
                 UnixCrypt::SHA256.build('password', 'password')
               end

  before(:all) do
    Specinfra.backend.run_command(
      <<-EOS
        echo '#{hostname}:#{port}:#{app_db}:#{app_user}:#{app_passwd}' > ~/.pgpass
        chmod 0600 ~/.pgpass
      EOS
    )
  end

  describe command("psql -U #{app_user} -d #{app_db} -h #{hostname} -p #{port} -c '\\l'") do
    its(:exit_status) { should eq 0 }
  end

  after(:all) do
    Specinfra.backend.run_command('rm -f ~/.pgpass')
  end
end
