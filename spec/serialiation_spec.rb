require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'Lwes' do
  describe'Serialization' do
    shared_examples_for 'all serializers' do
      it "should parse" do
        @bin_strs.each_with_index do |io, i|
          @klass.read(io).should == @values[i]
        end
      end
      
      it "should serialize" do
        @values.each_with_index do |v, i|
          @klass.new(v).to_binary_s.should == @bin_strs[i]
        end
      end
    end

    describe 'Boolean' do
      before :each do
        @klass = Lwes::Serialization::Boolean
        @values = [true, false]
        @bin_strs = ["\001", "\000"]
      end
      it_should_behave_like "all serializers"
    end
    
    describe 'NameStr' do
      before :each do
        @klass = Lwes::Serialization::NameStr
        @values = ["test", "test2", "another test", ""]
        @bin_strs = ["\004test", "\005test2", "\014another test", "\000"]
      end
      it_should_behave_like "all serializers"
    end
    
    describe 'AttrStr' do
      before :each do
        @klass = Lwes::Serialization::AttrStr
        @values = ["test", "test2", "another test", ""]
        @bin_strs = ["\000\004test", "\000\005test2", "\000\014another test", "\000\000"]
      end
      it_should_behave_like "all serializers"
    end
    
    describe 'IpAddr' do
      before :each do
        @klass = Lwes::Serialization::IpAddr
        @values = ["1.2.3.4", "0.0.0.0", "1.0.0.255"]
        @bin_strs = ["\001\002\003\004", "\000\000\000\000", "\001\000\000\377"]
      end
      it_should_behave_like "all serializers"
    end
    
    describe 'IpV4' do
      before :each do
        @klass = Lwes::Serialization::IpV4
        @values = ["1.2.3.4", "0.0.0.0", "1.0.0.255"]
        @bin_strs = ["\004\003\002\001", "\000\000\000\000", "\377\000\000\001"]
      end
      it_should_behave_like "all serializers"
    end

    describe 'IpV4' do
      before :each do
        @klass = Lwes::Serialization::IpV4
        @values = ["1.2.3.4", "0.0.0.0", "1.0.0.255"]
        @bin_strs = ["\004\003\002\001", "\000\000\000\000", "\377\000\000\001"]
      end
      it_should_behave_like "all serializers"
    end
    
    describe 'Uint16Array' do
      before :each do
        @klass = Lwes::Serialization::Uint16Array
        @values = [[1,2,3], [2,2,2,2], [1], []]
        @bin_strs = [
          "\000\003\000\001\000\002\000\003",
          "\000\004\000\002\000\002\000\002\000\002",
          "\000\001\000\001",
          "\000\000"
        ]
      end
      it_should_behave_like "all serializers"
    end
    
    describe 'Int16Array' do
      before :each do
        @klass = Lwes::Serialization::Int16Array
        @values = [[-1,2,3], [2,2,-2,2], [1], []]
        @bin_strs = [
          "\000\003\377\377\000\002\000\003",
          "\000\004\000\002\000\002\377\376\000\002",
          "\000\001\000\001",
          "\000\000"
        ]
      end
      it_should_behave_like "all serializers"
    end
    
    describe 'Uint32Array' do
      before :each do
        @klass = Lwes::Serialization::Uint32Array
        @values = [[1,2,3], [2,2,2,2], [1], []]
        @bin_strs = [
          "\000\003\000\000\000\001\000\000\000\002\000\000\000\003", 
          "\000\004\000\000\000\002\000\000\000\002\000\000\000\002\000\000\000\002",
          "\000\001\000\000\000\001", 
          "\000\000"
        ]
      end
      it_should_behave_like "all serializers"
    end

    describe 'Int32Array' do
      before :each do
        @klass = Lwes::Serialization::Int32Array
        @values = [[1,-2,3], [2,2,2,-2], [-1], []]
        @bin_strs = [
          "\000\003\000\000\000\001\377\377\377\376\000\000\000\003", 
          "\000\004\000\000\000\002\000\000\000\002\000\000\000\002\377\377\377\376",
          "\000\001\377\377\377\377", 
          "\000\000"
        ]
      end
      it_should_behave_like "all serializers"
    end

    describe 'AttrStrArray' do
      before :each do
        @klass = Lwes::Serialization::AttrStrArray
        @values = [["test", "test2", "test3"], ["", "", ""], []]
        @bin_strs = [
          "\000\003\000\004test\000\005test2\000\005test3", 
          "\000\003\000\000\000\000\000\000",
          "\000\000"
        ]
      end
      it_should_behave_like "all serializers"
    end

    describe 'IpAddrArray' do
      before :each do
        @klass = Lwes::Serialization::IpAddrArray
        @values = [["1.2.3.4", "0.0.0.0", "1.0.0.255"], []]
        @bin_strs = [
          "\000\003\001\002\003\004\000\000\000\000\001\000\000\377",
          "\000\000"
        ]
      end
      it_should_behave_like "all serializers"
    end
    
    describe 'Int64Array' do
      before :each do
        @klass = Lwes::Serialization::Int64Array
        @values = [[1,2,-3,4],[]]
        @bin_strs = [
          "\000\004\000\000\000\000\000\000\000\001\000\000\000\000\000\000\000\002\377\377\377\377\377\377\377\375\000\000\000\000\000\000\000\004",
          "\000\000"
        ]
      end
      it_should_behave_like "all serializers"
    end

    describe 'Uint64Array' do
      before :each do
        @klass = Lwes::Serialization::Int64Array
        @values = [[1,2,3,4],[]]
        @bin_strs = [
          "\000\004\000\000\000\000\000\000\000\001\000\000\000\000\000\000\000\002\000\000\000\000\000\000\000\003\000\000\000\000\000\000\000\004",
          "\000\000"
        ]
      end
      it_should_behave_like "all serializers"
    end
    
    describe 'BooleanArray' do
      before :each do
        @klass = Lwes::Serialization::BooleanArray
        @values = [[false],[]]
        @bin_strs = [
          "\000\001\000",
          "\000\000"
        ]
      end
      it_should_behave_like "all serializers"
    end
    
    describe 'Uint8Array' do
      before :each do
        @klass = Lwes::Serialization::Uint8Array
        @values = [[1,2, 255],[]]
        @bin_strs = [
          "\000\003\001\002\377",
          "\000\000"
        ]
      end
      it_should_behave_like "all serializers"
    end
    
    describe 'FloatArray' do
      before :each do
        @klass = Lwes::Serialization::FloatArray
        @values = [[2.0, 1.0],[]]
        @bin_strs = [
          "\000\002\100\000\000\000\077\200\000\000",
          "\000\000"
        ]
      end
      it_should_behave_like "all serializers"
    end
    
    describe 'DoubleArray' do
      before :each do
        @klass = Lwes::Serialization::DoubleArray
        @values = [[0.1, 1.0],[]]
        @bin_strs = [
          "\000\002\077\271\231\231\231\231\231\232\077\360\000\000\000\000\000\000",
          "\000\000"
        ]
      end
      it_should_behave_like "all serializers"
    end
    
    describe 'IpV4Array' do
      before :each do
        @klass = Lwes::Serialization::IpV4Array
        @values = [["1.2.3.4", "0.0.0.0", "1.0.0.255"], []]
        @bin_strs = [
          "\000\003\004\003\002\001\000\000\000\000\377\000\000\001",
          "\000\000"
        ]
      end
      it_should_behave_like "all serializers"
    end

    describe 'Attribute' do
      before :each do
        @klass = Lwes::Serialization::Attribute
        @values = [
          ["att0", :attr_str, "test123"],
          ["att1", :uint16, 1],
          ["att2", :ip_v4_array, ["1.2.3.4", "0.0.0.0", "1.0.0.255"]]
        ]
        @bin_strs = [
          "\004att0\005\000\007test123",
          "\004att1\001\000\001",
          "\004att2\215\000\003\004\003\002\001\000\000\000\000\377\000\000\001"
        ]
      end
      it_should_behave_like "all serializers"
    end

    describe 'AttributeArray' do
      before :each do
        @klass = Lwes::Serialization::AttributeArray
        @values = [
          [
            ["att0", :attr_str, "test123"],
            ["att1", :uint16, 1],
            ["att2", :ip_v4_array, ["1.2.3.4", "0.0.0.0", "1.0.0.255"]]
          ],
          [
          ]
        ]
        @bin_strs = [
          "\000\003\004att0\005\000\007test123\004att1\001\000\001\004att2\215\000\003\004\003\002\001\000\000\000\000\377\000\000\001",
          "\000\000"
        ]
      end
      it_should_behave_like "all serializers"
    end

    describe 'Event' do
      before :each do
        @klass = Lwes::Serialization::Event
        @values = [
          {'name' =>"event1", 'attributes' => [
            ["att0", :attr_str, "test123"],
            ["att1", :uint16, 1],
            ["att2", :ip_v4_array, ["1.2.3.4", "0.0.0.0", "1.0.0.255"]]
          ]}
        ]
        @bin_strs = [
          "\006event1\000\003\004att0\005\000\007test123\004att1\001\000\001\004att2\215\000\003\004\003\002\001\000\000\000\000\377\000\000\001"
        ]
      end
      it_should_behave_like "all serializers"
    end
  end
end