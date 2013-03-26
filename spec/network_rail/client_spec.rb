require 'spec_helper'

describe NetworkRail::Client do
  before do
    @stomp_client = stub("Stomp::Client",
      open?: true,
      protocol: Stomp::SPL_11,
      connection_frame: stub(command: true),
      subscribe: stub(true)
    )
  end

  describe "#new" do
    context "without login credentials" do
      it "raises an exception" do
        lambda {
          client = described_class.new
        }.should raise_exception(NetworkRail::Exception::NoLoginCredentials)
      end
    end

    context "with login credentials" do
      before(:all) do        
        NetworkRail.configure do |config|
          config.user_name = 'test'
          config.password = 'test'
        end
      end
      
      it "passes the login credentials in the request" do
        Stomp::Client.should_receive(:new).once do |options|
          options[:hosts][0][:login].should == 'test'
          options[:hosts][0][:passcode].should == 'test'
        end.and_return(@stomp_client)
        client = described_class.new
      end
      
      context "after connection attempt" do
        before(:each) do
          Stomp::Client.stub(:new).and_return(@stomp_client)
        end
        
        context "when there is a connection error" do
          it "raises an exception" do
            @stomp_client.stub(:open?).and_return(false)
            lambda {
              client = described_class.new
            }.should raise_exception(NetworkRail::Exception::ConnectionError)
          end
        end

        context "when there is an authentication error" do
          it "raises an exception" do
            @stomp_client.stub(:connection_frame).and_return(stub(command: Stomp::CMD_ERROR, body: "java.lang.SecurityException: User name [test] or password is invalid. (RuntimeError)"))
            lambda {
              client = described_class.new
            }.should raise_exception(NetworkRail::Exception::AuthenticationError)
          end
        end

        context "when there is an unexpected error" do
          it "raises an exception" do
            @stomp_client.stub(:connection_frame).and_return(stub(command: Stomp::CMD_ERROR, body: ''))
            lambda {
              client = described_class.new
            }.should raise_exception(NetworkRail::Exception::ConnectionError)
          end
        end
        
        context "when the connection is established" do
          it "returns an instance of #{described_class.to_s}" do
            client = described_class.new
            client.should be_kind_of described_class
          end
        end
      end
    end
  end
  
  describe "#train_movements" do
    before do
      NetworkRail.configure do |config|
        config.user_name = 'test'
        config.password = 'test'
      end
      Stomp::Client.stub(:new).and_return(@stomp_client)
      
      @client = described_class.new
    end
    
    context "with no block" do
      it "raises an exception" do
        lambda { @client.train_movements }.should raise_exception(NetworkRail::Exception::BlockRequired)
      end
    end
    
    context "with no train operator parameter" do
      it "defaults to all train operators and subscribes to the train movements feed" do
        @stomp_client.should_receive(:subscribe).once.with("/topic/TRAIN_MVT_ALL_TOC")
        @client.train_movements {|i| }
      end
    end
    
    context "with train operator parameter" do
      it "maps the operator parameter to the Network Rail business code and subscribes to the train movements feed" do
        @stomp_client.should_receive(:subscribe).once.with("/topic/TRAIN_MVT_HY_TOC")
        @client.train_movements(operator: :south_west_trains) {|i| }
      end
    end
    
    describe "parsing responses" do
      before do
        @stomp_client.stub(:subscribe).and_yield(fixture('train_movements.json'))
      end
      
      it "calls NetworkRail::Message::TrainMovement#factory for each message received" do
        NetworkRail::Message::TrainMovement.should_receive(:factory).exactly(10).times
        @client.train_movements {|i| }
      end
      
      it "yields an instance of NetworkRail::Message::TrainMovement for each message received" do
        expect {|b| @client.train_movements(&b) }.to yield_successive_args(
          NetworkRail::Message::TrainMovement::Arrival,
          NetworkRail::Message::TrainMovement::Departure,
          NetworkRail::Message::TrainMovement::Arrival,
          NetworkRail::Message::TrainMovement::Departure,
          NetworkRail::Message::TrainMovement::Departure,
          NetworkRail::Message::TrainMovement::Arrival,
          NetworkRail::Message::TrainMovement::Arrival,
          NetworkRail::Message::TrainMovement::Arrival,
          NetworkRail::Message::TrainMovement::Departure,
          NetworkRail::Message::TrainMovement::Departure
        )
      end
    end
  end
end