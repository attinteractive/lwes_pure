require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Lwes do
  describe "Helpers" do
    include Lwes::Helpers
    it "should camelcase" do
      camelcase("camel_case_it").should == "CamelCaseIt"
    end
  end

  describe "Event" do
    before :each do
      @event_attr = {:name =>"event1", :attributes => {
        "att0" => [:attr_str, "test123"],
        "att1" => [:uint16, 1],
        "att2" => [:ip_v4_array, ["1.2.3.4", "0.0.0.0", "1.0.0.255"]]
      }}
      @binary = "\006event1\000\003\004att0\005\000\atest123\004att1\001\000\001\004att2\215\000\003\004\003\002\001\000\000\000\000\377\000\000\001"
    end
    
    it "should write to io" do
      io = StringIO.new
      event = Lwes::Event.new(@event_attr)
      event.write(io)
      io.rewind
      io.read.should == @binary
    end
    
    it "should read from io" do
      io = StringIO.new(@binary)
      event = Lwes::Event.read(io)
      event.name.should == @event_attr[:name]
      event.attributes.should == @event_attr[:attributes]
    end
    
    it "should convert to hash" do
      event = Lwes::Event.new(@event_attr)
      event.to_hash.should == @event_attr
    end
  end
  
  describe "Emitter" do
    before :each do
      @emitter_options = {
        :address_family => "fake address family",
        :host => "fake address",
        :port => "fake port"
      }
      @mock_socket = mock("socket")
      UDPSocket.should_receive(:new).with("fake address family").and_return(@mock_socket)
      @mock_socket.should_receive(:connect).with("fake address", "fake port")
    end

    it "should initialize udp socket on instanitation" do
      Lwes::Emitter.new @emitter_options
    end
    
    it "should write to udp socket when emitting event" do
      binary = "\006event1\000\003\004att0\005\000\atest123\004att1\001\000\001\004att2\215\000\003\004\003\002\001\000\000\000\000\377\000\000\001"
      @mock_socket.should_receive(:write).with(binary)
      
      emitter = Lwes::Emitter.new @emitter_options
      event = Lwes::Event.new({:name =>"event1", :attributes => {
        "att0" => [:attr_str, "test123"],
        "att1" => [:uint16, 1],
        "att2" => [:ip_v4_array, ["1.2.3.4", "0.0.0.0", "1.0.0.255"]]
      }})
      
      emitter.emit event
    end
    
    
  end
end
