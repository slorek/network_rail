require 'spec_helper'

describe NationalRail::Client do
  describe "#new" do
    before do
      @stomp_client = stub("Stomp::Client",
        open?: true,
        protocol: Stomp::SPL_11,
        connection_frame: stub(command: true)
      )
    end
    
    context "without login credentials" do
      it "raises an exception" do
        lambda {
          client = described_class.new
        }.should raise_exception(NationalRail::Exception::NoLoginCredentials)
      end
    end

    context "with login credentials" do
      before(:all) do        
        NationalRail.configure do |config|
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
            }.should raise_exception(NationalRail::Exception::ConnectionError)
          end
        end

        context "when there is an authentication error" do
          it "raises an exception" do
            @stomp_client.stub(:connection_frame).and_return(stub(command: Stomp::CMD_ERROR, body: "java.lang.SecurityException: User name [test] or password is invalid. (RuntimeError)"))
            lambda {
              client = described_class.new
            }.should raise_exception(NationalRail::Exception::AuthenticationError)
          end
        end

        context "when there is an unexpected error" do
          it "raises an exception" do
            @stomp_client.stub(:connection_frame).and_return(stub(command: Stomp::CMD_ERROR, body: ''))
            lambda {
              client = described_class.new
            }.should raise_exception(NationalRail::Exception::ConnectionError)
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
end