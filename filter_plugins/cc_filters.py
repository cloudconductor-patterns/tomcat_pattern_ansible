# Common filters
def deep_get(cc_attributes, nested_keys):
  if cc_attributes == None:
    return None

  current_dict = cc_attributes
  for key in nested_keys.split('.'):
    if current_dict.has_key(key):
      current_dict = current_dict[key]
    else:
      return None
  else:
    return current_dict

# CloudConductor Attributes filters
def fetch_role_servers(attrs, role):
  servers = attrs['cloudconductor']['servers']
  return dict((x,y) for x,y in filter(lambda x: x[1]['roles'].count(role) > 0, servers.items()))

def first_server(cc_attributes, role):
  servers = fetch_role_servers(cc_attributes, role)
  first_server_key = sorted(servers.keys())[0]
  return {first_server_key: servers[first_server_key]}

def first_db_server(cc_attributes):
  return first_server(cc_attributes, 'db')

def first_ap_server(cc_attributes):
  return first_server(cc_attributes, 'ap')

def first_server_ip(server):
  return server[server.keys()[0]]['private_ip']

def first_ap_server_ip(cc_attributes):
  if cc_attributes == None:
    return None

  try:
    server = first_ap_server(cc_attributes)
    ret_ip = first_server_ip(server)
  except KeyError, e:
    ret_ip = None

  return ret_ip

def first_db_server_ip(cc_attributes):
  if cc_attributes == None:
    return None

  try:
    server = first_db_server(cc_attributes)
    ret_ip = first_server_ip(server)
  except KeyError, e:
    ret_ip = None

  return ret_ip


class FilterModule(object):
  ''' Ansible CloudConductor jinja2 filters '''

  def filters(self):
    return {
      'deep_get': deep_get,
      'first_ap_server_ip': first_ap_server_ip,
      'first_db_server_ip': first_db_server_ip
    }
