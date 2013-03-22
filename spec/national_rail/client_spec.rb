require 'spec_helper'

describe NationalRail::Client do
  
  let(:user_name) { 'test' }
  let(:password) { 'test' }
  
  describe "#new" do
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
          config.user_name = user_name
          config.password = password
        end
      end
      
      it "passes the login credentials in the request" do
        Stomp::Client.any_instance.should_receive(:new).once.with(hash_including(hosts: [hash_including(login: user_name, password: password)]))
        client = described_class.new
      end
      
      context "after connection attempt" do
        before(:each) do
          @stomp_client = stub("Stomp::Client",
            open?: true,
            protocol: Stomp::SPL_11,
            connection_frame: {
              command: true
            }
          )
          
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
            lambda {
              client = described_class.new
            }.should raise_exception(NationalRail::Exception::AuthenticationError)
          end
        end

        context "when there is an unexpected error" do
          it "raises an exception" do
            @stomp_client.stub(:connection_frame).and_return({ command: Stomp::CMD_ERROR })
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