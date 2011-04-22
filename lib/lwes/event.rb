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
    
    def name=(v)
      @name = v
    end

    def attributes=(v)
      @attributes = v
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
      e = new
      e.read(io)
      e
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
      attributes.collect do |k, v|
        [ k, v[0], v[1] ]
      end
    end
    
    def set_attributes_from_serializer(serializer)
      @name = serializer.name
      @attributes = serializer.attributes.inject({}) do |h, attribute|
        k, t, v = *attribute
        # convert to real string
        k = k.to_s
        # convert BinData types to actual types
        v = v.value

        h[k] = [t, v]
        h
      end
    end
  end
end