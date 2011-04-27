module Lwes
  module Validation
    REGEX_IPV4 = /\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b/
    
    class ValidationError < Exception; end
    
    def validate!
      validates_name_str(name, "name")
      if attributes
        validates_instance_of(attributes, ::Hash, "attributes")
        attributes.each do |key, value|
          validates_name_str(key, "attribute key #{key}")
          validates_attr_type_value(value, "value of attribute[#{key}]")
        end
      end
      true
    end
    
    def valid?
      begin
        validate!
      rescue ValidationError => e
        false
      end
    end
    
private
    
    def validates_presence_of(obj, name)
      raise ValidationError, "'#{name}' must be specified." unless obj
    end
    
    def validates_instance_of(obj, klass, name)
      raise ValidationError, "'#{name}' must be a #{klass.name}." unless obj.is_a?(klass)
    end
    
    def validates_size_of(obj, range, name)
      raise ValidationError, "'#{name}' size must be at least." unless obj.size >= range.min
      raise ValidationError, "'#{name}' is too long, max length is #{a.max}." unless obj.size <= range.max
    end
    
    def validates_range_of(obj, range, name)
      raise ValidationError, "'#{name}' must be a value between #{a.min} and #{a.max}" unless range.include?(obj)
    end
    
    def validates_ip_format_of(obj, name)
      raise ValidationError, "'#{name}' must be an ip address." unless obj =~ REGEX_IPV4
    end
    
    def validates_inclusion_of(obj, ary, name)
      raise ValidationError, "'#{name}' must be one of #{ary.inspect}, but was #{obj.inspect}" unless ary.include?(obj)
    end
    
    def validates_typed_array_of(obj, klass, name)
      validates_presence_of(obj, name)
      validates_instance_of(obj, ::Array, name)
      validates_size_of(obj, 0..65535, name)
      raise ValidationError, "'#{name}' must be an array of the same class type." if obj.any?{ |v| !v.is_a?(klass) }
    end
    
    def validates_name_str(obj, name)
      validates_presence_of(obj, name)
      validates_instance_of(obj, ::String, name)
      validates_size_of(obj, 1..255, name)
    end
    
    def validates_attr_type_value(obj, name)
      validates_instance_of(obj, ::Array, name)
      raise ValidationError, "'#{name}' must be an array of 2 elements specifying type and data" unless obj.size == 2
      validates_inclusion_of(obj[0], Lwes::TYPE_TO_BYTE.keys, "#{name}[0]")
      send "validates_#{obj[0]}", obj[1], "#{name}[1]"
    end
    
    def validates_boolean(obj, name)
      validates_presence_of(obj, name)
      raise ValidationError, "'#{name}' must be either true or false." unless obj.is_a?(TrueClass) || obj.is_a?(FalseClass)
    end
    
    def validates_attr_str(obj, name)
      validates_presence_of(obj, name)
      validates_instance_of(obj, ::String, name)
      validates_size_of(obj, 0..65535, name)
    end
    
    def validates_uint8(obj, name)
      validates_presence_of(obj, name)
      validates_instance_of(obj, ::Fixnum, name)
      validates_range_of(obj, 0..255, name)
    end
    
    def validates_uint16(obj, name)
      validates_presence_of(obj, name)
      validates_instance_of(obj, ::Fixnum, name)
      validates_range_of(obj, 0..65535, name)
    end
    
    def validates_int16(obj, name)
      validates_presence_of(obj, name)
      validates_instance_of(obj, ::Fixnum, name)
      validates_range_of(obj, -32768..32767, name)
    end
    
    def validates_uint32(obj, name)
      validates_presence_of(obj, name)
      validates_instance_of(obj, ::Fixnum, name)
      validates_range_of(obj, 0..4294967295, name)
    end

    def validates_int32(obj, name)
      validates_presence_of(obj, name)
      validates_instance_of(obj, ::Fixnum, name)
      validates_range_of(obj, -2147483648..2147483647, name)
    end
    
    def validates_uint64(obj, name)
      validates_presence_of(obj, name)
      validates_instance_of(obj, ::Fixnum, name)
      validates_range_of(obj, 0..18446744073709551615, name)
    end

    def validates_int64(obj, name)
      validates_presence_of(obj, name)
      validates_instance_of(obj, ::Fixnum, name)
      validates_range_of(obj, -9223372036854775808..9223372036854775807, name)
    end
    
    def validates_float(obj, name)
      validates_presence_of(obj, name)
      validates_instance_of(obj, ::Float, name)
    end
    
    def validates_ip_addr(obj, name)
      validates_presence_of(obj, name)
      validates_instance_of(obj, ::String, name)
      validates_ip_format_of(obj, name)
    end
    
    def validates_boolean_array(obj, name)
      validates_typed_array_of(obj, name)
      obj.each_with_index{ |v, i| validates_boolean(v, "#{name}[#{i}]") }
    end
    
    def validates_attr_str_array(obj, name)
      validates_typed_array_of(obj, name)
      obj.each_with_index{ |v, i| validates_attr_str(v, "#{name}[#{i}]") }
    end
    
    def validates_uint8_array(obj, name)
      validates_typed_array_of(obj, name)
      obj.each_with_index{ |v, i| validates_uint8(v, "#{name}[#{i}]") }
    end
    
    def validates_uint16_array(obj, name)
      validates_typed_array_of(obj, name)
      obj.each_with_index{ |v, i| validates_uint16(v, "#{name}[#{i}]") }
    end
    
    def validates_int16_array(obj, name)
      validates_typed_array_of(obj, name)
      obj.each_with_index{ |v, i| validates_int16(v, "#{name}[#{i}]") }
    end
    
    def validates_uint32_array(obj, name)
      validates_typed_array_of(obj, name)
      obj.each_with_index{ |v, i| validates_uint32(v, "#{name}[#{i}]") }
    end
    
    def validates_int32_array(obj, name)
      validates_typed_array_of(obj, name)
      obj.each_with_index{ |v, i| validates_int32(v, "#{name}[#{i}]") }
    end
    
    def validates_uint64_array(obj, name)
      validates_typed_array_of(obj, name)
      obj.each_with_index{ |v, i| validates_uint64(v, "#{name}[#{i}]") }
    end
    
    def validates_int64_array(obj, name)
      validates_typed_array_of(obj, name)
      obj.each_with_index{ |v, i| validates_int64(v, "#{name}[#{i}]") }
    end
    
    def validates_float_array(obj, name)
      validates_typed_array_of(obj, name)
      obj.each_with_index{ |v, i| validates_float(v, "#{name}[#{i}]") }
    end

    def validates_ip_addr_array(obj, name)
      validates_typed_array_of(obj, ::String, name)
      obj.each_with_index{ |v, i| validates_ip_addr(v, "#{name}[#{i}]") }
    end
    
    alias :validates_double :validates_float
    alias :validates_ip_v4 :validates_ip_addr
    alias :validates_double_array :validates_float_array
    alias :validates_ip_v4_array :validates_ip_addr_array
  end
end