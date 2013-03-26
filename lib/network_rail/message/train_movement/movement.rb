require "network_rail/message/train_movement/base"

module NetworkRail
  module Message
    module TrainMovement
      class Movement < Base
        
        require "network_rail/message/train_movement/arrival"
        require "network_rail/message/train_movement/departure"
        
        attr_accessor :time, :planned_time
        
        def self.factory(json_message)
          event_type = json_message['body']['event_type']
          target_class = event_type == 'ARRIVAL' ? Arrival : Departure
          target_class.new(json_message)
        end
        
        def initialize(json_message)
          super
          self.time = Time.at (json_message['body']['actual_timestamp'].to_i / 1000).to_i
          self.planned_time = Time.at (json_message['body']['planned_timestamp'].to_i / 1000).to_i
        end
        
        def on_time?
          delay <= NetworkRail.late_threshold
        end
        
        def delay
          (time - planned_time).round
        end
      end
    end
  end
end