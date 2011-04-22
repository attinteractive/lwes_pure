require 'bindata'
require 'lwes/types'
require 'lwes/helpers'
require 'lwes/serialization'

module Lwes
  class Event
    attr_accessor :name, :attributes
    def initialize(hash={})
      self.name = hash[:name] || ""
      self.attributes = hash[:attributes] || {}
    end
    
    def name=(val)
      @name = val
    end

    def attributes=(val)
      @attributes = val
    end
    
    def write(io)
      serializer.write(io)
    end
    
    def read(io)
      serializer = Lwes::Serialization::Event.read(io)
      set_attributes_from_serializer(serializer)
      self
    end
    
    def self.read(io)
      event = new
      event.read(io)
      event
    end
    
    def to_hash
      {
        :name => name,
        :attributes => attributes
      }
    end

  private
    def serializer
      Lwes::Serialization::Event.new(:name => name, :attributes => attributes_to_serializer)
    end

    def attributes_to_serializer
      attributes.collect do |key, value|
        [ key, value[0], value[1] ]
      end
    end
    
    def set_attributes_from_serializer(serializer)
      @name = serializer.name
      @attributes = serializer.attributes.inject({}) do |hash, attribute|
        key, vtype, value = *attribute
        # convert to real string
        key = key.to_s
        # convert BinData types to actual types
        value = value.value

        hash[key] = [vtype, value]
        hash
      end
    end
  end
end