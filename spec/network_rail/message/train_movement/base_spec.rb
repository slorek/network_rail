require 'spec_helper'

describe NetworkRail::Message::TrainMovement::Base do
  describe "#factory" do
    it "returns an instance of the class" do
      described_class.should_receive(:new).once.with('test')
      described_class.factory('test')
    end
  end
  
  describe "#initialize" do
    before do
      @messages = JSON.parse fixture('train_movements.json')
    end
    
    it "assigns the original parsed JSON message to #original_message" do
      object = described_class.new @messages.first
      object.original_message.should == @messages.first
    end
  end
end