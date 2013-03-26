require "network_rail/message/train_movement/base"

module NetworkRail
  module Message
    module TrainMovement
      class Movement < Base
        
        require "network_rail/message/train_movement/arrival"
        require "network_rail/message/train_movement/departure"
        
        def self.factory(json_message)
          event_type = json_message['body']['event_type']
          target_class = event_type == 'ARRIVAL' ? Arrival : Departure
          target_class.new(json_message)
        end
      end
    end
  end
end