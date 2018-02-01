#
# Author:: Taliesin Sisson (<taliesins@yahoo.com>)
# Cookbook Name:: sagecrmeenbuwebservices
# Attributes:: default
# Copyright 2014-2015, Chef Software, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

default['sagecrmenbuwebservices']['filename'] = 'Enbu Webservices Framework 2.2'
default['sagecrmenbuwebservices']['filename'] = 'exe'
default['sagecrmenbuwebservices']['url'] = 'http://www.yourserver.com/' + node['sagecrmenbuwebservices']['filename'] + '.' + node['sagecrmenbuwebservices']['filename']
default['sagecrmenbuwebservices']['checksum'] = '49ca95bfb041a5501a27d82435d6dafb4ec37c7bf0a2c28d76d01cfcf3e43e66'
default['sagecrmenbuwebservices']['home'] = "#{Chef::Config['file_cache_path']}/#{node['sagecrmenbuwebservices']['filename']}/#{node['sagecrmenbuwebservices']['checksum']}"
default['sagecrmenbuwebservices']['path'] = 'C:\Program Files (x86)\Sage\CRM\CRM\WWWRoot\CustomPages\Enbu\Framework'

default['sagecrmenbuwebservices']['application']['crm']['name'] = node['sagecrm']['application']['crm']['name'] || 'CRM'
default['sagecrmenbuwebservices']['instance']['install_dir'] = node['sagecrm']['instance']['install_dir']  || 'C:\\Program Files (x86)\\Sage\\CRM\\'
default['sagecrmenbuwebservices']['application']['crm']['physical_path'] = node['sagecrm']['application']['crm']['physical_path'] || "#{node['sagecrmenbuwebservices']['instance']['install_dir']}#{node['sagecrmenbuwebservices']['application']['crm']['name']}\\WWWRoot"
default['sagecrmenbuwebservices']['application']['enbuwebservices']['physical_path'] = "#{node['sagecrmenbuwebservices']['application']['crm']['physical_path']}\\CustomPages\\Enbu\\Framework"

default['sagecrmenbuwebservices']['service']['account'] = node['sagecrm']['service']['account'] || '.\SageCRM' # e.g. SageCRM. This account is used to access the database server, so ensure that database permission have been configured. This account is used to run service, so ensure that it has the correct permissions on each node. If using multiple nodes, active directory is required.
default['sagecrmenbuwebservices']['service']['password'] = node['sagecrm']['service']['password'] || 'P@ssw0rd' # e.g. P@ssw0rd. This is the password to use if creating a windows account locally to use.
default['sagecrmenbuwebservices']['installaccount']['account'] = node['sagecrm']['installaccount']['account'] ||  node['sagecrmenbuwebservices']['service']['account']
default['sagecrmenbuwebservices']['installaccount']['password'] = node['sagecrm']['installaccount']['password'] || node['sagecrmenbuwebservices']['service']['password']

username = node['sagecrmenbuwebservices']['service']['account']
domain = ''

if username.include? '\\'
  domain = username.split('\\')[0]
  username = username.split('\\')[1]
end

if username.include? '@'
  domain = username.split('@')[1]
  username = username.split('@')[0]
end

if domain == '' || domain == '.'
  domain = node['hostname']
end

default['sagecrmenbuwebservices']['database']['database_name'] = node['sagecrm']['database']['database_name'] || 'CRM'
default['sagecrmenbuwebservices']['properties']['User'] = username
default['sagecrmenbuwebservices']['properties']['Password'] = node['sagecrmenbuwebservices']['service']['password']
default['sagecrmenbuwebservices']['database']['host'] = node['sagecrm']['database']['host'] || '127.0.0.1'
default['sagecrmenbuwebservices']['usex3interfaces'] = true
