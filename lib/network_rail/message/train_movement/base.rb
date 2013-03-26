module NetworkRail
  module Message
    module TrainMovement
      class Base
        def initialize(json_message)
        end

        def self.factory(json_message)
          self.new(json_message)
        end
      end
    end
  end
end