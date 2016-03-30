import os
import consul
import json
import ast

def token_key():
    return os.environ.get('CONSUL_SECRET_KEY')

def kvs_all_keys():
    c = consul.Consul()
    index, data = c.kv.get('', token=token_key(), keys=True)
    return data

def kvs_cc_keys():
    cc_keys= filter(lambda x:x.startswith('cloudconductor/'), kvs_all_keys())
    return cc_keys

def kvs_get(key):
    c = consul.Consul()
    index, data = c.kv.get(key, token=token_key())
    return data

def deep_merge(source, destination):
    for key, value in source.items():
        if isinstance(value, dict):
            # get node or create one
            node = destination.setdefault(key, {})
            deep_merge(value, node)
        else:
            destination[key] = value

    return destination


if __name__ == '__main__':
    cc_keys = kvs_cc_keys()
    cc_values = map(lambda x:ast.literal_eval(kvs_get(x)['Value']), cc_keys)
    cc_attributes = reduce(lambda x, y:deep_merge(x, y), cc_values)
    print json.dumps(cc_attributes)
    exit(0)
