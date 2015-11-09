require 'spec_helper'

describe 'db_configure' do
  db_user = 'user'
  db_name = 'application'

  it 'is created application database' do
    expect(command("sudo -u postgres psql -U #{db_user} -d #{db_name} -c '\\l'").exit_status).to eq(0)
  end

  it 'is created pg_hba file' do
    expect(file('/var/lib/pgsql/.pgpass'))
      .to be_file
  end

  it 'is created .pgpass file' do
    expect(file('/var/lib/pgsql/9.4/data/pg_hba.conf'))
      .to be_file
      .and be_mode(600)
  end
end
