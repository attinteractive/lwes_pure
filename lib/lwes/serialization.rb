module Lwes
  module Serialization
    extend Lwes::Helpers
    
    class Boolean < BinData::BasePrimitive
      register_self

      def value_to_binary_string(value)
        value ? 1.chr : 0.chr
      end

      def read_and_return_value(io)
        byte = read_uint8(io)
        byte != 0 # 0 is false, everything else is true
      end

      def sensible_default
        false
      end

      def read_uint8(io)
        io.readbytes(1).unpack("C").at(0)
      end
    end

    class NameStr < BinData::Primitive
      endian :big
      uint8  :len,  :initial_value => lambda { data.length }
      string :data, :initial_value => lambda { value }, :read_length => :len

      def get
        self.data
      end
      
      def set(val)
        self.data = val
      end
    end

    class AttrStr < BinData::Primitive
      endian :big
      uint16 :len,  :initial_value => lambda { data.length }
      string :data, :initial_value => lambda { value }, :read_length => :len

      def get;   self.data;     end
      def set(val) self.data = val; end
    end

    class IpAddr < BinData::Primitive
      endian :little
      uint32 :data, :initial_value => lambda { ip_to_int32(value) }
      
      def ip_to_int32(str)
        ary = str.to_s.split(".").collect{ |byte| byte.to_i }.slice(0,4)
        ((ary[3] & 0xff) << 24) + ((ary[2] & 0xff) << 16) + ((ary[1] & 0xff) << 8) + (ary[0] & 0xff)
      end
      
      def int32_to_ip(num)
        ary = []
        
        4.times do
          ary << (num & 0xff)
          num = num >> 8
        end

        ary.join(".")
      end
            
      def get
        self.int32_to_ip(self.data)
      end
      
      def set(val)
        self.data = ip_to_int32(val)
      end
    end

    class IpV4 < BinData::Primitive
      endian :big
      uint32 :data, :initial_value => lambda { ip_to_int32(value) }
      
      def ip_to_int32(str)
        ary = str.to_s.split(".").collect{ |byte| byte.to_i }.slice(0,4)
        ((ary[3] & 0xff) << 24) + ((ary[2] & 0xff) << 16) + ((ary[1] & 0xff) << 8) + (ary[0] & 0xff)
      end
      
      def int32_to_ip(num)
        ary = []
        
        4.times do
          ary << (num & 0xff)
          num = num >> 8
        end

        ary.join(".")
      end
            
      def get
        self.int32_to_ip(self.data)
      end
      
      def set(val)
        self.data = ip_to_int32(val)
      end
    end

    Lwes::TYPE_TO_BYTE.keys.select{|key| key.to_s =~ /_array/}.each do |key|
      key = key.to_s
      klass_name = camelcase(key.to_s)
      type = key.gsub(/_array/, '')
    
      class_eval <<-END
        class #{klass_name} < BinData::Primitive
          endian    :big
          uint16    :len,  :initial_value => lambda{ data.length }
          array     :data, :type => :'#{type}', :initial_length => :len
      
          def assign(val)
            super
            self.data = value
          end
      
          def get;   self.data;     end
          def set(val) self.data = val; end
        end
      END
    end



    class Attribute < BinData::Primitive
      endian    :big
      name_str  :key,   :initial_value => lambda { extract_key(value) }
      uint8     :vtype, :initial_value => lambda { extract_type(value) }
      choice    :val,   :selection => :vtype, :choices => Lwes::BYTE_TO_TYPE
      
      def assign(val)
        super
        self.val = extract_value(val)
      end
      
      def extract_key(val)
        val[0]
      end
      
      def extract_type(val)
        Lwes::TYPE_TO_BYTE[val[1]]
      end
      
      def extract_value(val)
        val[2]
      end
      
      def get
        [self.key, BYTE_TO_TYPE[self.vtype], self.val]
      end

      def set(val)
        self.key = extract_key(val)
        self.vtype = extract_type(val)
        self.val = extract_value(val)
      end
    end


    class AttributeArray < BinData::Primitive
      endian    :big
      uint16    :len,  :value => lambda{ data.length }
      array     :data, :type => :attribute, :initial_length => :len
      
      def assign(val)
        super
        self.data = []
        value.each do |attribute|
          self.data << attribute
        end
      end

      def get
        self.data
      end
      
      def set(val)
        self.data = []
        val.each do |attribute|
          self.data << attribute
        end
      end
    end

    class Event < BinData::Record
      endian   :big
      name_str :name
      attribute_array :attributes
    end
  end
end
