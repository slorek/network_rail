require "date"
require "network_rail/message/train_movement/movement"
require "network_rail/message/train_movement/activation"
require "network_rail/message/train_movement/cancellation"
require "network_rail/message/train_movement/change_of_identity"
require "network_rail/message/train_movement/change_of_origin"
require "network_rail/message/train_movement/reinstatement"

module NetworkRail
  module Message
    module TrainMovement
      def self.factory(json_message)
        target_class = message_type_to_class_mapping[json_message['header']['msg_type']]
        target_class.factory(json_message)
      end
    
      private
      
        def self.message_type_to_class_mapping
          {
            '0001' => Activation,
            '0002' => Cancellation,
            '0003' => Movement,
            '0005' => Reinstatement,
            '0006' => ChangeOfOrigin,
            '0007' => ChangeOfIdentity
          }
        end
    end
  end
end
