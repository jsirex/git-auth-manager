$LOAD_PATH << File.dirname(File.expand_path(__FILE__).to_s).to_s
require 'rubygems'
require 'yaml'
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

loop {
  begin
    # update all admin repositories
    gconnectors.each {|gcon| gcon.load}

    active_users = []
    connectors.each do |connector|
      active_users += connector.getUsers
    end

    active_users = active_users.uniq

    gconnectors.each do |gcon|
      gcon.disableUsers(gcon.getUsers - active_users)
      gcon.enableUsers(active_users - gcon.getUsers)
    end

    gconnectors.each { |gcon| gcon.save}
  rescue Exception => e
    puts e
    puts e.backtrace
    puts "Got exception but ignoring"
  end

  break if ARGV.find_index("--do-not-loop")

  puts "Sleeping for 300 seconds..."
  sleep(300)
}
