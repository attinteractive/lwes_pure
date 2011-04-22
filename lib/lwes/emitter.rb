require 'socket'

module Lwes
  # Emit LWES events to a UDP endpoint
  class Emitter
    DEFAULT_SOCIKET_OPTIONS = {
      :address_family => Socket::AF_INET,
      :host           => "127.0.0.1",
      :port           => 12345
    }
    
    attr_accessor :socket_options, :socket
    
    # Creates a new {Lwes::Emitter}.
    # @param [Hash] options
    # @option options [String] :host UDP host address, defaults to 127.0.0.1
    # @option options [String, Number] :port UDP port, defaults to 12345
    # @option options [Number] :address_family, Address family of the socket, defaults to Socket::AF_INET
    def initialize(options={})
      self.socket_options = DEFAULT_SOCIKET_OPTIONS.merge(options)
      self.socket = UDPSocket.new(@socket_options[:address_family])
      socket.connect(@socket_options[:host], @socket_options[:port])
    end

    # Emits specified event
    # @param [Lwes::Event] event The event to send
    # @return [Number] the number of bytes sent
    def emit(event)
      buffer = StringIO.new
      event.write(buffer)
      buffer.rewind
      socket.write(buffer.read)
    end
    
  end
end