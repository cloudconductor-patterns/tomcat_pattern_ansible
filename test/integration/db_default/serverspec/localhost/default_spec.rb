require 'spec_helper'

describe 'db_default' do
  db_user = 'user'
  db_name = 'application'

  it 'is installed postgresql 9.4 server pakcage' do
    expect(package('postgresql94-server')).to be_installed
  end

  it 'is installed postgresql 9.4 devel package' do
    expect(package('postgresql94-devel')).to be_installed
  end

  it 'is installed postgresql 9.4 contrib package' do
    expect(package('postgresql94-contrib')).to be_installed
  end

  it 'is installed python-psycopg2 package' do
    expect(package('python-psycopg2')).to be_installed
  end

  it 'is initialized postgresql db and created db user' do
    expect(command("sudo -u postgres psql -U postgres -d postgres -c '\\l'").exit_status).to eq(0)
  end

  it 'is created application database' do
    expect(command("sudo -u postgres psql -U #{db_user} -d #{db_name} -c '\\l'").exit_status).to eq(0)
  end

  it 'is created pg_hba file' do
    expect(file('/var/lib/pgsql/.pgpass'))
      .to be_file
  end

  it 'is replace listen_addresses on posgresql.conf' do
    expect(file('/var/lib/pgsql/9.4/data/postgresql.conf'))
      .to be_file
      .and contain('listen_addresses = \'*\'')
  end

  it 'is created .pgpass file' do
    expect(file('/var/lib/pgsql/9.4/data/pg_hba.conf'))
      .to be_file
      .and be_mode(600)
  end
end
