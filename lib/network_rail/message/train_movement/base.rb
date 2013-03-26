module NetworkRail
  module Message
    module TrainMovement
      class Base
        
        attr_accessor :original_message
        
        def initialize(json_message)
          self.original_message = json_message
        end

        def self.factory(json_message)
          self.new(json_message)
        end
      end
    end
  end
end