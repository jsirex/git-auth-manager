$LOAD_PATH << File.dirname(File.expand_path(__FILE__).to_s).to_s
require 'rubygems'
require 'daemons'
require 'yaml'
require 'git'
require 'connectors/all'

CONFIG=File.dirname(__FILE__) + "/config.yml"

def symbolize_hash(hash)
  hash.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
end

# auth connectors
connectors = Array.new
# git connectors
gconnectors = Array.new

conf = symbolize_hash(YAML::load_file CONFIG)


conf.each do |connector,config|
  config = symbolize_hash(config)
  puts "Processing connector: #{connector} (#{config[:name]})"
  case connector
    when :ldap
      connectors += [CONNECTOR::LdapConnector.new(config)]
    when :crowd
      connectors += [CONNECTOR::CrowdConnector.new(config)]
    when :git
      gconnectors += [CONNECTOR::GitConnector.new(config)]
    else
      puts "Unsupported type of connector"
  end
end

gconnectors.each do |gcon|
  gcon.prepare
  puts gcon.getUsers
end




puts connectors.inspect
#
#
#
#connectors.each do |connector|
#  connector.
#end
#
