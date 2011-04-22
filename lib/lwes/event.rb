require 'bindata'
require 'lwes/types'
require 'lwes/helpers'
require 'lwes/serialization'

module Lwes
  # Represent a LWES event, can read from and write to IO objects
  class Event
    attr_accessor :name, :attributes
    
    # Creates a new {Lwes::Emitter}.
    # @param [Hash] hash
    # @option hash [String] :name The event name
    # @option hash [Hash] :attributes Attributes of the event.
    #                                 The hash key is the attribute name, the hash value should be an Array of two elements.
    #                                 The first element is the type see {Lwes::TYPE_TO_BYTE} for all available types.
    #                                 The second element is the actual value of the attribute.
    # @option hash [Number] :address_family, Address family of the socket, defaults to Socket::AF_INET.
    def initialize(hash={})
      self.name = hash[:name] || ""
      self.attributes = hash[:attributes] || {}
    end

    # Writes the event to an IO object
    # @param [IO] io The IO object to write to.
    # @return [Number] Number of bytes written to IO
    def write(io)
      serializer.write(io)
    end

    # Read from an IO object
    # @param [IO] io The IO object to read from.
    def read(io)
      serializer = Lwes::Serialization::Event.read(io)
      set_attributes_from_serializer(serializer)
    end
    
    # Read from an IO object
    # @param [IO] io The IO object to read from.
    # @return [Lwes::Event] a new {Lwes::Event} instance with data filled from the IO.
    def self.read(io)
      event = new
      event.read(io)
      event
    end
    
    # Converts the event to a hash representation
    # @return [Hash] the hash representation of the instance.
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