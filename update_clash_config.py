#!/usr/bin/python


import yaml
import os
import requests


config_file_path = '/etc/clash/config.yaml'


with open(config_file_path, mode='r') as config_file:
    config = yaml.load(config_file)

download_config = yaml.load(requests.get(config['config_url']).content)


proxies = download_config['proxies']


for idx, proxy in enumerate(proxies):
    proxy['name'] = idx


config['proxies'] = proxies


proxy_names = [i for i in range(len(proxies))]
proxy_name_with_direct = proxy_names.copy()
proxy_name_with_direct.append('DIRECT')


config['proxy-groups'][0]['proxies'] = proxy_names
config['proxy-groups'][1]['proxies'] = proxy_names
config['proxy-groups'][2]['proxies'] = proxy_names
config['proxy-groups'][3]['proxies'] = proxy_name_with_direct


with open(config_file_path, mode='w') as config_file:
    yaml.dump(config, config_file)


os.system('sudo systemctl restart clash')
