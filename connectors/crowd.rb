module CONNECTOR
  class CrowdConnector
    def initialize(config)
      @url = config[:url]
      @appname = config[:appname]
      @apppasword = config[:apppassword]
    end

    def inspect
      "Connector: \"#{@url} #{@appname}@<password>\""
    end

    def getUsers
      # TODO: get users from crowd
      []
    end
  end
end