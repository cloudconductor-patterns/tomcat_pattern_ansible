require 'spec_helper'
require 'unix_crypt'

describe 'db_configure' do
  db_user = 'user'
  db_name = 'application'
  hostname = 'localhost'
  port = '5432'

  it 'is created application database' do
    expect(command("sudo -u postgres psql -U #{db_user} -d #{db_name} -c '\\l'").exit_status).to eq(0)
  end

  it 'is created pg_hba file' do
    expect(file('/var/lib/pgsql/9.4/data/pg_hba.conf'))
      .to be_file
  end

  it 'is created .pgpass file' do
    expect(file('/var/lib/pgsql/.pgpass'))
      .to be_file
      .and be_mode(600)
  end

  it 'is db_users password made from salt' do
    passwd = UnixCrypt::SHA256.build('testsalt', 'password')
    Specinfra.backend.run_command(
      <<-EOS
        echo '#{hostname}:#{port}:#{db_name}:#{db_user}:#{passwd}' > ~/.pgpass
        chmod 0600 ~/.pgpass
      EOS
    )
    expect(command("psql -U #{db_user} -d #{db_name} -h #{hostname} -p #{port} -c '\\l'").exit_status).to eq(0)
    Specinfra.backend.run_command('rm -f ~/.pgpass')
  end
end
