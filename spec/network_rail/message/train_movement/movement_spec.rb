require 'spec_helper'

describe NetworkRail::Message::TrainMovement::Movement do
  before do
    @messages = JSON.parse fixture('train_movements.json')
  end
  
  describe "#factory" do
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
  
  describe "#initialize" do
    it "converts actual_timestamp to Time and assigns to #time" do
      object = described_class.new @messages.first
      object.time.should be_a Time
      object.time.year.should == 2013
    end

    it "converts planned_timestamp to Time and assigns to #planned_time" do
      object = described_class.new @messages.first
      object.planned_time.should be_a Time
      object.planned_time.year.should == 2013
    end

    it "converts toc_id to a symbol representing the train operator and assings to #operator" do
      object = described_class.new @messages.first
      object.operator.should == :south_west_trains
    end
  end
  
  describe "#on_time?" do
    context "when within the late threshold" do
      it "returns true" do
        object = described_class.new @messages.first
        object.time = Time.now
        object.planned_time = Time.now - 1.minute
        object.on_time?.should == true
      end
    end

    context "when outside the late threshold" do
      it "returns false" do
        object = described_class.new @messages.first
        object.time = Time.now
        object.planned_time = Time.now - 1.hour
        object.on_time?.should == false
      end
    end
  end
  
  describe "#delay" do
    it "returns the difference in seconds between #time and #planned_time" do
      object = described_class.new @messages.first
      object.time = Time.now
      object.planned_time = Time.now - 1.hour
      object.delay.should == 3600
    end
  end
end