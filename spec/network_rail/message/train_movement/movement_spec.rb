require 'spec_helper'

describe NetworkRail::Message::TrainMovement::Movement do
  describe "#factory" do
    before do
      @messages = JSON.parse fixture('train_movements.json')
    end
    
    it "calls the factory method on a different subclass depending on the message type" do
      @messages.each do |message|
        target_class = case message['body']['event_type']
          when "ARRIVAL" then NetworkRail::Message::TrainMovement::Arrival
          when "DEPARTURE" then NetworkRail::Message::TrainMovement::Departure
        end
        
        target_class.should_receive :new
        described_class.factory(message)
      end
    end
  end
end