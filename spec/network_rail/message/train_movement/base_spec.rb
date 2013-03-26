require 'spec_helper'

describe NetworkRail::Message::TrainMovement::Base do
  describe "#factory" do
    it "returns an instance of the class" do
      described_class.should_receive(:new).once.with('test')
      described_class.factory('test')
    end
  end
end