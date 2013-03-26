require 'spec_helper'

describe NetworkRail::Message::TrainMovement do
  describe "#factory" do
    before do
      @messages = JSON.parse fixture('train_movements.json')
    end
    
    it "calls the factory method on a different subclass of NetworkRail::Message::TrainMovement::Base depending on the message type" do
      @messages.each do |message|
        target_class = case message['header']['msg_type']
          when "0001" then NetworkRail::Message::TrainMovement::Activation
          when "0002" then NetworkRail::Message::TrainMovement::Cancellation
          when "0003" then NetworkRail::Message::TrainMovement::Movement
          when "0005" then NetworkRail::Message::TrainMovement::Reinstatement
          when "0006" then NetworkRail::Message::TrainMovement::ChangeOfOrigin
          when "0007" then NetworkRail::Message::TrainMovement::ChangeOfIdentity
        end
        
        target_class.should_receive(:factory).once
        described_class.factory(message)
      end
    end
  end
end