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
      
      operator_code = business_codes[args[:operator]]
      
      client.subscribe("/topic/TRAIN_MVT_#{operator_code}_TOC") do |msg|
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
      
      def business_codes
        {
          all: 'ALL',
          all_passenger: 'PASSENGER',
          freight: 'GENERAL',
          arriva_trains_wales: 'HL',
          c2c: 'HT',
          chiltern_railway: 'HO',
          cross_country: 'EH',
          devon_and_cornwall_railway: 'EN',
          east_midlands_trains: 'EM',
          east_coast: 'HB',
          eurostar: 'GA',
          first_capital_connect: 'EG',
          first_great_western: 'EF',
          first_hull_trains: 'PF',
          first_scotrail: 'HA',
          first_transpennine_xpress: 'EA',
          gatwick_express: 'HV',
          grand_central: 'EC',
          heathrow_connect: 'EE',
          heathrow_express: 'HM',
          island_lines: 'HZ',
          london_midland: 'EJ',
          london_overground: 'EK',
          london_underground_bakerloo_line: 'XC',
          london_underground_district_line_wimbledon: 'XB',
          london_underground_district_line_richmond: 'XE',
          merseyrail: 'HE',
          greater_anglia: 'EB',
          nexus: 'PG',
          north_yorkshire_moors_railway: 'PR',
          northern_rail: 'ED',
          south_west_trains: 'HY',
          south_eastern: 'HU',
          southern: 'HW',
          virgin_trains: 'HF',
          west_coast_railway: 'PA',
        }
      end
  end
end
