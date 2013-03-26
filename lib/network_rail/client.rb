require "stomp"
require "json"
require "network_rail/operators"
require "network_rail/exception/authentication_error"
require "network_rail/exception/block_required"
require "network_rail/exception/connection_error"
require "network_rail/exception/no_login_credentials"

module NetworkRail
  class Client
    
    HOST_NAME = 'datafeeds.networkrail.co.uk'
    HOST_PORT = 61618
    
    def initialize
      raise Exception::NoLoginCredentials if NetworkRail.user_name.nil? or NetworkRail.password.nil?
      
      self.client = Stomp::Client.new(connection_parameters)
      
      raise Exception::ConnectionError unless client.open?
      
      if client.connection_frame().command == Stomp::CMD_ERROR
        raise Exception::AuthenticationError if client.connection_frame().body.match /SecurityException/
        raise Exception::ConnectionError
      end
    end
    
    def train_movements(args = {operator: :all}, &block)
      raise Exception::BlockRequired if !block
      
      operator_code = NetworkRail::Operators.business_codes[args[:operator]]
      
      client.subscribe("/topic/TRAIN_MVT_#{operator_code}_TOC") do |message|
        movements = JSON.parse message
        movements.each {|movement| yield NetworkRail::Message::TrainMovement.factory(movement) }
      end
    end
    
    private
    
      attr_accessor :client
    
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
              login:    NetworkRail.user_name,
              passcode: NetworkRail.password,
              host:     HOST_NAME,
              port:     HOST_PORT
            }
          ],
          connect_headers: connection_headers
        }
      end
    end
end
