module CONNECTOR
  class LdapConnector
    def initialize(config)
      @host = config[:host]
      @binddn = config[:binddn]
      @username = config[:username]
      @password = config[:password]
    end

    def inspect
      "Connector: \"#{@host} (#{@binddn}) #{@username}@<password>\""
    end

  end
end