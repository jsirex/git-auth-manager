require 'ldap'
module CONNECTOR
  class LdapConnector
    def initialize(config)
      @host = config[:host]
      @port = config[:port]
      @binddn = config[:binddn]
      @username = config[:username]
      @password = config[:password]
      @filter = config[:filter]
      @attr = config[:uid]
    end

    def inspect
      "Connector: \"#{@host} (#{@binddn}) #{@username}@<password>\""
    end

    def getUsers
      conn = LDAP::Conn.new(@host, @port)
      conn.bind(@username, @password)
      users = Array.new
      conn.search(@binddn, LDAP::LDAP_SCOPE_SUBTREE, @filter, @attr) do |entry|
        users += entry.vals(@attr) if entry.vals(@attr)
      end
      users.map {|x| x.downcase}
    end

  end
end