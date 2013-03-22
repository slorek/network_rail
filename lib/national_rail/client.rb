module NationalRail
  class Client
    
    HOST_NAME = 'datafeeds.networkrail.co.uk'
    HOST_PORT = 61618
    
    def initialize
      raise Exception::NoLoginCredentials if NationalRail.user_name.nil? or NationalRail.password.nil?
      
      client = Stomp::Client.new(connection_parameters)
      
      raise Exception::ConnectionError unless client.open?
      
      if client.connection_frame().command == Stomp::CMD_ERROR
        raise Exception::AuthenticationError if client.connection_frame().body.match /SecurityException/
        raise Exception::ConnectionError
      end
    end
    
    private
      def connection_headers
        {
          "accept-version" => "1.1",
          "host"           => HOST_NAME
        }
      end
      
      def connection_parameters
        {
          hosts: [
            {
              login:    NationalRail.user_name,
              passcode: NationalRail.password,
              host:     HOST_NAME,
              port:     HOST_PORT
            }
          ],
          connect_headers: connection_headers
        }
      end
  end
end
