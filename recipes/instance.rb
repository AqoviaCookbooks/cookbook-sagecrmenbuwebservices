#
# Cookbook Name:: sagecrmenbuwebservices
# Recipe:: default
#
# Copyright (C) 2015 Taliesin Sisson
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'autoit'

if node['sagecrmenbuwebservices']['service']['account'] == ''
  raise 'Please configure Sage CRM Enbu Webservices service_account attribute'
end

if node['sagecrmenbuwebservices']['service']['password'] == ''
  raise 'Please configure Sage CRM Enbu Webservices service_account_password attribute'
end

if node['sagecrmenbuwebservices']['service']['password'] == ''
  raise 'Please configure Sage CRM Enbu Webservices service_account_password attribute'
end

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

::Chef::Recipe.send(:include, Windows::Helper)

working_directory = File.join(Chef::Config['file_cache_path'], '/sagecrmenbuwebservices')

directory working_directory do
  recursive true
end

sagecrm_enbu_webservices_install_script_path = File.join(working_directory, 'EnbuWebServicesInstall.au3')
sagecrm_enbu_webservices_install_exe_path = File.join(working_directory, 'EnbuWebServicesInstall.exe')

win_friendly_sagecrm_enbu_webservices_install_script_path = win_friendly_path(sagecrm_enbu_webservices_install_script_path)
win_friendly_sagecrm_enbu_webservices_install_exe_path = win_friendly_path(sagecrm_enbu_webservices_install_exe_path)

# Poor mans idempotency
sagecrm_enbu_webservices_installed = ::File.directory?(node['sagecrmenbuwebservices']['application']['enbuwebservices']['physical_path'])
filename = File.basename(node['sagecrmenbuwebservices']['url']).downcase

installation_directory = File.join(working_directory, node['sagecrmenbuwebservices']['checksum'])
win_friendly_installation_directory = win_friendly_path(installation_directory)

download_path = File.join(win_friendly_installation_directory, filename)

template sagecrm_enbu_webservices_install_script_path do
  source 'EnbuWebServicesInstall.au3.erb'
  variables(
    WorkingDirectory: win_friendly_installation_directory,
    SetupFileName: filename
  )
  not_if { sagecrm_enbu_webservices_installed }
end

execute "Check syntax #{win_friendly_sagecrm_enbu_webservices_install_script_path} with AutoIt" do
  command "\"#{File.join(node['autoit']['home'], '/Au3Check.exe')}\" \"#{win_friendly_sagecrm_enbu_webservices_install_script_path}\""
  not_if { sagecrm_enbu_webservices_installed }
end

execute "Compile #{win_friendly_sagecrm_enbu_webservices_install_script_path} with AutoIt" do
  command "\"#{File.join(node['autoit']['home'], '/Aut2Exe/Aut2exe.exe')}\" /in \"#{win_friendly_sagecrm_enbu_webservices_install_script_path}\" /out \"#{win_friendly_sagecrm_enbu_webservices_install_exe_path}\" "
  not_if { sagecrm_enbu_webservices_installed }
end

remote_file download_path do
  source node['sagecrmenbuwebservices']['url']
  checksum node['sagecrmenbuwebservices']['checksum']
  not_if { sagecrm_enbu_webservices_installed }
end

win_friendly_psexec_path = win_friendly_path(File.join(node['pstools']['home'], 'psexec.exe'))
win_friendly_rdpplus_path = win_friendly_path(File.join(node['rdpplus']['home'], 'rdp.exe'))
win_friendly_powershell_helper_path = win_friendly_path(File.join(node['autoit']['home'], 'Invoke-InDesktopSession.ps1'))

powershell_script 'Install-SageCrmEnbuWebServices' do
  code <<-EOH1
. "#{win_friendly_powershell_helper_path}"

$username = '#{node['sagecrmenbuwebservices']['installaccount']['account']}'
$password = '#{node['sagecrmenbuwebservices']['installaccount']['password']}'
$command = '#{win_friendly_sagecrm_enbu_webservices_install_exe_path}'
$psexecPath = '#{win_friendly_psexec_path}'
$rdpplusPath = '#{win_friendly_rdpplus_path}'

$ErrorActionPreference = "Stop"

#We are unable to run the installer in a way that will allow it to start sage crm services in interactive mode. If the services exist that means the install is complete.
$result = Invoke-InDesktopSession -username $username -password $password -command $command -psexecPath $psexecPath -rdpplusPath $rdpplusPath

if ($result.StandardOutput){
  Write-Output $result.StandardOutput
}
if ($result.ErrorOutput){
  Write-Error $result.ErrorOutput
}
exit $result.ExitCode

EOH1
  action :run
  not_if { sagecrm_enbu_webservices_installed }
end
